module GitHub
  # Handles low-level HTTP requests
  class Browser
    include Singleton
    
    # Returnes root uri for GitHub API
    def self.base_uri
      "http://github.com/api/v2/yaml"
    end
    
    # Runs HTTP GET request at given uri
    def self.get(uri)
      uri = uri.gsub(" ","+")
      puts "Requesting #{URI.parse(self.base_uri + uri)}"
      Net::HTTP.get URI.parse(self.base_uri + uri)
    end
    
    # Runs HTTP POST requests with options such as GitHub::User.auth_info
    def self.post(uri, options = {})
      uri = uri.gsub(" ","+")
      puts "Requesting #{URI.parse(self.base_uri + uri)} with options: #{options}"
      Net::HTTP.post_form URI.parse(self.base_uri + uri), options
    end
  end
end
