module GitHub
  # Handles low-level HTTP requests
  class Browser
    include Singleton
    
    # Returnes root uri for GitHub API
		# @param [Object] *options only for backwards compatibility!
    # @return [String] Base GitHub API url
    def self.base_uri(*options)
      gh_uri = GitHub::Config::Options[:server]||'api.github.com'
      "http://#{gh_uri}/"
    end
    
    # Runs HTTP GET request at given uri
    # @param [String] uri URI to be joined with base_uri and requested
    # @return [String] request result
    def self.get(uri, version = 'v2')
      uri = URI.parse(self.base_uri(version) + uri.gsub(" ","+"))
      puts "Requesting #{uri}" if GitHub::Config::Options[:verbose]
      Net::HTTP.get uri
    end
    
    # Runs HTTP POST requests with options such as GitHub::User.auth_info
    # @param [String] uri URI to be joined with base_uri and requested
    # @return [String] request result
    def self.post(uri, options = {}, version = 'v2')
      uri = URI.parse(self.base_uri(version) + uri.gsub(" ","+"))
      puts "Requesting #{uri} with options: #{options}" if GitHub::Config::Options[:verbose]
      Net::HTTP.post_form uri, options
    end

    # Runs HTTP PATCH request at a given uri
    # @param [String] uri URI to be joined with base_uri and requested
    # @return [String] request result
    def self.patch(uri, options = {}, version = 'v2')
      uri = uri.gsub(" ","+")
      puts "Requesting #{URI.parse(self.base_uri(version) + uri)} with options: #{options}" if GitHub::Config::Options[:verbose]
      Net::HTTP.patch URI.parse(self.base_uri + uri), options
    end
  end
end
