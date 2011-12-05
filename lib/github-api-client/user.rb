module GitHub
  # Basic model, stores retrieved user and his associations
  class User < ActiveRecord::Base
    has_and_belongs_to_many :followers, :foreign_key => 'follower_id', :association_foreign_key => 'following_id', :join_table => 'user_followings', :class_name => 'User'
    has_and_belongs_to_many :followings, :foreign_key => 'following_id', :association_foreign_key => 'follower_id', :join_table => 'user_followings', :class_name => 'User'
    has_many :repos, :class_name => 'GitHub::Repo', :as => :owner
    
    # FIXME: Does GitHub allow a user to have multiple organizations?
    has_and_belongs_to_many :organizations, :join_table => 'organizations_members'
    
    # Fetches info about current_user from GitHub
    # GitHub::User.new.build(:login => 'asd', :token => 'token').get #=> GitHub::User
    # @return [GitHub::User] Chainable self object after syncing attributes with GitHub
    def get
      self.update_attributes(
        GitHub::Base.parse_attributes(:user_get,
          YAML::load(
            GitHub::Browser.get("/user/show/#{self.login}"))['user']))
      self
    end
    
    # Static function, that gets information about GitHub::User by login.
    # === Examples
    #  GitHub::User.get('defunkt') #=> GitHub::User
    # @param [String] login GitHub user login to fetch
    # @return [GitHub::User] Newly created, in local database user synced with github
    def self.get(login)
      if u = GitHub::User.find_by_login(login)
        u.get
      else
        u = GitHub::User.new(:login => login).fetch(:self)
      end
    end
    
    # Searches for users in GitHub database
    # @param [String] login GitHub user login to search
    # @return [Array<GitHub::User>] All users that matched login
    def self.search(login)
      users = []
      YAML::load(GitHub::Browser.get("/user/search/#{login}"))['users'].each do |user|
        users << GitHub::User.find_or_create_by_login(GitHub::Base.parse_attributes(:user_search, user))
      end
      users
    end
    
    # Experimental function, requests POST transmission to custom path of GitHub API
    # @param [Array] route Route splitted like: ['users', 'search', 'chacon']
    # @param [Hash] options Options to pass with the request
    # @option [Hash] options 'values[email]' => 'test@api.com'
    def set(route = [], options = {})
      return GitHub::Browser.post "/#{route.join('/')}", options.merge(self.auth_info)
    end
    
    # End-user way to fetch information
    # @param [Array<Symbol>] things Things to fetch for GitHub::User
    # @option things [Symbol] :self Sync with GitHub Database
    # @option things [Symbol] :followers Map followers from GitHub Database
    # @option things [Symbol] :followings Map user's followings from GitHub
    # @return [GitHub::User] Chainable, updated User
    # @see GitHub::User#get
    # @see GitHub::User#get_followers
    def fetch(*things)
      things.each do |thing|
        case thing
          when :self then get
          when :followers then get_followers
          when :followings then get_followings
          when :organizations then get_organizations
          when :repos then get_repos
        end
      end
      self
    end
    
    # Executes when you got a real object
    # @see GitHub::User#fetch
    # @return GitHub::User Chainable after mapping followers association
    private 
    def get_followers
      users = YAML::load(GitHub::Browser.get "/user/show/#{login}/followers")['users'] || []
      puts "Fetching followers for #{"user".color(:yellow).bright} #{self.login.dup.color(:green).bright}"
      i, count = 0, users.count.to_s.color(:green).bright
      self.transaction do
        users.each do |user|
          i += 1
          u = GitHub::User.find_or_create_by_login(user)
          self.followers.find_or_create u
          print "\r#{i.to_s.color(:yellow).bright}/#{count}"
        end
      end
      puts nil
      self
    end
    
    def get_followings
      users = YAML::load(GitHub::Browser.get "/user/show/#{login}/following")['users'] || []
      puts "Fetching followings for #{"user".color(:yellow).bright} #{self.login.dup.color(:green).bright}"
      i, count = 0, users.count.to_s.color(:green).bright
      self.transaction do
        users.each do |user|
          i += 1
          u = GitHub::User.find_or_create_by_login(user)
          self.followings.find_or_create u
          print "\r#{i.to_s.color(:yellow).bright}/#{count}"
        end
      end
      puts nil
      self
    end
    
    def get_organizations
      organizations = YAML::load(GitHub::Browser.get "/user/show/#{login}/organizations")['organizations'] || []
      puts "Fetching organizations for #{"user".color(:yellow).bright} #{self.login.dup.color(:green).bright}"
      i, count = 0, organizations.count.to_s.color(:green).bright
      self.transaction do
        organizations.each do |org|
          i += 1
          u = GitHub::Organization.find_or_create_by_login(org['login'])
          self.organizations.find_or_create u
          print "\r#{i.to_s.color(:yellow).bright}/#{count}"
        end
      end
      puts nil
      self
    end
    
    # Executes when you got a real object
    # @see GitHub::User#fetch
    # @return GitHub::User Chainable after mapping followers association
    def get_repos
      repos = YAML::load(GitHub::Browser.get "/repos/show/#{login}")['repositories'] || []
      puts "Fetching repositories for #{"user".color(:yellow).bright} #{self.login.dup.color(:green).bright}"
      i, count = 0, repos.count.to_s.color(:green).bright
      self.transaction do
        repos.each do |repo|
          i += 1
          u = GitHub::User.find_or_create_by_login(repo[:owner])
          r = GitHub::Repo.where(:owner_id => u.id, :name => repo[:name]).first
          r ||= GitHub::Repo.create(:owner => u, :name => repo[:name])
          print "\r#{i.to_s.color(:yellow).bright}/#{count}"
        end
      end
      puts nil
      self
    end

    public
    # Returns an array with logins of GitHub::User followers
    # @param [String] login GitHub login of which followers will be mapped
    # @return [Array<GitHub::User>] Followers
    # @deprecated It should not support such way, there should be objects!
    def self.get_followers(login)
      users = YAML::load(GitHub::Browser.get "/user/show/#{login}/followers")['users']
      
      # Loading each user (not effective with 688 followers like schacon has)
      objects = []
      i = 1
      users.each do |user|
        puts "#{users.length.to_s} / #{i.to_s} - Fetching followers"
        i = i + 1
        u = GitHub::User.find_or_create_by_login(user)
        objects << u
      end
      return objects
    end
    
    # Collects information from authenticated user.
    # Used by post requests to authenticate
    # @return [Hash] Collected from GitHub::User options for HTTP POST request authentication
    def auth_info
      {:login => self.login, :token => self.token}
    end
    
    # Experimental, sets information about GitHub::User or returns authenticated :self
    # @param [String] login Login to which post request will be sent
    # @param [Hash] options Options to include to a post request
    # @option options [Hash] email 'values[email]' => 'test@api.com' - Sets user email to test@api.com if authenticated
    # @return [String] Request retrieved data
    def post(login, options = {})
      if [:self, :me].include? login
        login = self.login
      end
      return GitHub::Browser.post "/user/show/#{login}", options.merge(self.auth_info)
    end
  end
end
