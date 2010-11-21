module GitHub
  class Browser
    include Singleton
    
    def self.base_uri
      "http://github.com/api/v2/yaml"
    end
    
    def self.get(uri)
      puts "Requesting #{URI.parse(self.base_uri + uri)}"
      Net::HTTP.get URI.parse(self.base_uri + uri)
    end
    
    def self.post(uri, options = {})
      puts "Requesting #{URI.parse(self.base_uri + uri)} with options: #{options}"
      Net::HTTP.post_form URI.parse(self.base_uri + uri), options
    end
  end
end
