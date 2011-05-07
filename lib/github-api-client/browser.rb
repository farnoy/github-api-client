module GitHub
  # Handles low-level HTTP requests
  class Browser
    include Singleton
    
    # Returnes root uri for GitHub API
    # @param [String] version GitHub api keyword, defaults to v2
    # @option version "v1"
    # @option version "v2"
    # @option version "v3"
    # @return [String] Base GitHub API url for v2
    def self.base_uri(version = 'v2')
      "http://github.com/api/#{version}/yaml"
    end
    
    # Runs HTTP GET request at given uri
    # @param [String] uri URI to be joined with base_uri and requested
    # @return [String] request result
    def self.get(uri, version = 'v2')
      uri = uri.gsub(" ","+")
      puts "Requesting #{URI.parse(self.base_uri(version) + uri)}" if GitHub::Config::Options[:verbose]
      Net::HTTP.get URI.parse(self.base_uri + uri)
    end
    
    # Runs HTTP POST requests with options such as GitHub::User.auth_info
    # @param [String] uri URI to be joined with base_uri and requested
    # @return [String] request result
    def self.post(uri, options = {}, version = 'v2')
      uri = uri.gsub(" ","+")
      puts "Requesting #{URI.parse(self.base_uri(version) + uri)} with options: #{options}" if GitHub::Config::Options[:verbose]
      Net::HTTP.post_form URI.parse(self.base_uri + uri), options
    end
  end
end
