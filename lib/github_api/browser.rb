require 'singleton'
module GitHub
  class Browser
    include Singleton
    
    def self.base_uri
      GitHub.base_uri
    end
    
    def self.get(uri)
      Net::HTTP.get_print URI.parse(self.base_uri + uri)
    end
  end
end
