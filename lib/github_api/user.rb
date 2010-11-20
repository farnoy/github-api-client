module GitHub
  class User
    attr_accessor :login, :token
    
    def get(login)
      if login == :self
        GitHub::Browser.get "/user/show/#{self.login}"
      end
    end
  end
end
