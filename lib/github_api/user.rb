module GitHub
  class User < Base
    attr_accessor :login, :token
    
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
      return GitHub::Browser.get "/user/show/#{login}/followers"
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
