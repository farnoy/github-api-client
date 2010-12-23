module GitHub
  class Organization < ActiveRecord::Base
    def get
      self.update_attributes(
        GitHub::Base.parse_attributes(:org_get,
          YAML::load(
            GitHub::Browser.get("/organizations/#{self.login}"))['organization']))
      self
    end
    
    def self.get(login)
      o   = GitHub::Organization.find_by_login(login)
      o ||= GitHub::Organization.new(:login => login).get
    end
  end
end
