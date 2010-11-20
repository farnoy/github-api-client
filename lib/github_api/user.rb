module GitHub
  class User < Base
    attr_accessor :login, :token
    
    def get(login)
      if [:self, :me].include? login
        login = self.login
      end
      return GitHub::Browser.get "/user/show/#{login}"
    end
    
    def post(login, options = {})
      if [:self, :me].include? login
        login = self.login
      end
      auth_info = {:login => self.login, :token => self.token}
      return GitHub::Browser.post "/user/show/#{login}", options.merge(auth_info)
    end
  end
end
