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
      return GitHub::Browser.post "/user/show/#{login}", {:login => self.login, :token => self.token}
    end
  end
end
