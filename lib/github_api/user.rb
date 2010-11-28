module GitHub
  # Basic model, stores retrieved user and his associations
  class User < ActiveRecord::Base
    has_and_belongs_to_many :followers, :foreign_key => 'follower_id', :association_foreign_key => 'following_id', :join_table => 'followings', :class_name => 'User'
    has_and_belongs_to_many :following, :foreign_key => 'following_id', :association_foreign_key => 'follower_id', :join_table => 'followings', :class_name => 'User'
    
    # Fetches info about current_user from GitHub
    # GitHub::User.new.build(:login => 'asd', :token => 'token').get #=> GitHub::User
    def get
      self.update_attributes YAML::load(GitHub::Browser.get("/user/show/#{self.login}"))['user']
      self
    end
    
    # Static function, that gets information about GitHub::User by login.
    # === Examples
    #  GitHub::User.get('defunkt') #=> GitHub::User
    def self.get(login)
      return GitHub::User.find_or_create_by_login YAML::load(GitHub::Browser.get("/user/show/#{login}"))['user']
    end
    
    def self.search(login)
      users = []
      YAML::load(GitHub::Browser.get("/user/search/#{login}"))['users'].each do |user|
        p GitHub::User.find_or_create_by_login(GitHub::Base.parse_attributes(user))
      end
    end
    
    def set(route = [], options = {}) #:nodoc:
      return GitHub::Browser.post "/#{route.join('/')}", options.merge(self.auth_info)
    end
    
    # End-user way to fetch information
    def fetch(*things)
      things.each do |thing|
        case thing
          when :self then get
          when :followers then get_followers
        end
      end
      self
    end
    
    # Executes when you got a real object
    private 
    def get_followers
      users = YAML::load(GitHub::Browser.get "/user/show/#{login}/followers")['users']
      
      ids = []
      i = 1
      users.each do |user|
        puts "#{users.length.to_s} / #{i.to_s} - Fetching followers"
        i = i + 1
        u = GitHub::User.find_or_create_by_login(user)
        ids << u.id
      end
      
      self.follower_ids = ids
      self
    end
    
    # Returns an array with logins of GitHub::User followers
    public
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
    def auth_info
      {:login => self.login, :token => self.token}
    end
    
    # Experimental, sets information about GitHub::User or returns authenticated :self 
    def post(login, options = {})
      if [:self, :me].include? login
        login = self.login
      end
      return GitHub::Browser.post "/user/show/#{login}", options.merge(self.auth_info)
    end
  end
end
