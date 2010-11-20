require 'singleton'
module GitHub
  class Browser
    include Singleton
    
    def self.base_uri
      GitHub.base_uri
    end
    
    def self.get(uri)
      response = Net::HTTP.get URI.parse(self.base_uri + uri)
      y = YAML::load response
    end
    
    def self.post(uri, options = {})
      req = Net::HTTP.post_form URI.parse(self.base_uri + uri), options
    end
  end
end
