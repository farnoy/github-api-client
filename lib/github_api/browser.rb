require 'singleton'
module GitHub
  class Browser
    include Singleton
    
    def self.base_uri
      GitHub.base_uri
    end
    
    def self.get(uri)
      response = Net::HTTP.get URI.parse(self.base_uri + uri)
      p YAML::load response
    end
  end
end
