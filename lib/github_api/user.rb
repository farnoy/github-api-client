module GitHub
  class User < Base
    attr_accessor :login, :token
    
    def get(login)
      if login == :self
        login = self.login
      end
      return GitHub::Browser.get "/user/show/#{login}"
    end
  end
end
