module GitHub
  # Basic model, stores retrieved user and his associations
  class User < ActiveRecord::Base
    has_and_belongs_to_many :followers, :foreign_key => 'follower_id', :association_foreign_key => 'following_id', :join_table => 'following_followers', :class_name => 'User'
    has_and_belongs_to_many :following, :foreign_key => 'following_id', :association_foreign_key => 'follower_id', :join_table => 'following_followers', :class_name => 'User'
    
    # Fetches info about current_user from GitHub
    # GitHub::User.new.build(:login => 'asd', :token => 'token').get #=> GitHub::User
    def get
      self.update_attributes YAML::load(GitHub::Browser.get("/user/show/#{self.login}"))['user']
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
    
    # Returns an array with logins of GitHub::User followers
    def get_followers(login)
      if [:self, :me].include? login
        login = self.login
      end
      users = YAML::load(GitHub::Browser.get "/user/show/#{login}/followers")['users']
      
      # Loading each user (not effective with 688 followers like schacon has)
      objects = []
      i = 1
      users.each do |user|
        puts "#{users.length.to_s} / #{i.to_s}"
        i = i + 1
        p GitHub::User.get(user)
        #objects << u
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
