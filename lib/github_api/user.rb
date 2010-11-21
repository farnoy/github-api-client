module GitHub
  # Basic model, stores retrieved user and his associations
  class User < Base
    attr_accessor :attributes
    @attributes = %w(login token gravatar_id created_at public_repo_count public_gist_count following_count id type followers_count name company location blog email fullname language followers score record username repos pushed created).each do |attr|
      attr_accessor attr
    end
    
    def login_safe;@login || @name;end
    def followers_safe;@followers_count || @followers; end
    def repos_safe;@public_repo_count || @repos; end
    def name_safe;@fullname || @name; end
    
    # Fetches info about current_user from GitHub
    # GitHub::User.new.build(:login => 'asd', :token => 'token').get #=> GitHub::User
    def get
      self.build YAML::load(GitHub::Browser.get("/user/show/#{self.login}"))['user']
      self
    end
    
    # Static function, that gets information about GitHub::User by login.
    # === Examples
    #  GitHub::User.get('defunkt') #=> GitHub::User
    def self.get(login)
      return GitHub::Helper.build_from_yaml(GitHub::Browser.get("/user/show/#{login}"))
    end
    
    def self.search(login)
      return GitHub::Helper.build_from_yaml(GitHub::Browser.get("/user/search/#{login}"))
    end
    
    def set(route = [], options = {}) #:nodoc:
      return GitHub::Browser.post "/#{route.join('/')}", options.merge(self.auth_info)
    end
    
    # Returns an array with logins of GitHub::User followers
    def followers(login)
      if [:self, :me].include? login
        login = self.login
      end
      users = YAML::load(GitHub::Browser.get "/user/show/#{login}/followers")['users']
      
      # Loading each user (not effective with 688 followers like schacon has)
      #objects = []
      #users.each do |user|
      #  puts user
      #  u = GitHub::User.new
      #  u.build(YAML::load(GitHub::Browser.get("/user/show/#{user}"))['user'])
      #  objects << GitHub::Helper.build_from_yaml(GitHub::Browser.get("/user/show/#{user}"))
      #end
      return users
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
