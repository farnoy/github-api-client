module GitHub
  class User < Base
    attr_accessor :login, :token
    
    def get(login)
      if [:self, :me].include? login
        login = self.login
      end
      return GitHub::Browser.get "/user/show/#{login}"
    end
  end
end
