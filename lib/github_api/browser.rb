require 'singleton'
module GitHub
  class Browser
    include Singleton
    
    def self.base_uri
      GitHub.base_uri
    end
    
    def self.get(uri)
      Net::HTTP.get URI.parse(self.base_uri + uri)
    end
    
    def self.post(uri, options = {})
      Net::HTTP.post_form URI.parse(self.base_uri + uri), options
    end
  end
end
