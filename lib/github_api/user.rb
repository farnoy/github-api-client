module GitHub
  class User < Base
    %w(login token gravatar_id created_at public_repo_count public_gist_count following_count id type followers_count).each do |attr|
      attr_accessor attr
    end
    
    def get(login)
      if [:self, :me].include? login
        login = self.login
      end
      return GitHub::Browser.get "/user/show/#{login}"
    end
    
    def set(route = [], options = {})
      return GitHub::Browser.post "/#{route.join('/')}", options.merge(self.auth_info)
    end
    
    def followers(login)
      if [:self, :me].include? login
        login = self.login
      end
      users = YAML::load(GitHub::Browser.get "/user/show/#{login}/followers")['users']
      objects = []
      users.each do |user|
        u = GitHub::User.new
        u.build(YAML::load(GitHub::Browser.get("/user/show/#{user}"))['user'])
        p u
      end
      return objects
    end
    
    def auth_info
      {:login => self.login, :token => self.token}
    end
    
    def post(login, options = {})
      if [:self, :me].include? login
        login = self.login
      end
      return GitHub::Browser.post "/user/show/#{login}", options.merge(self.auth_info)
    end
  end
end
