module GitHub
  # Basic functionality inherited later
  class Base
    # Sends key= value signals at object, that inherits it
    def build(options = {})
      options.each_pair do |k, v|
        self.send "#{k.to_sym}=", v
      end
    end
     
    # Converts pitfalls from GitHub API differences into normal data
    def self.parse_attributes(attributes)
      {:name => :login, :username => :login, :fullname => :name, :followers => :followers_count, :repos => :public_repos_count}.each do |k, v|
        attributes[v] = attributes[k.to_s]
        attributes.delete k.to_s
      end
      attributes
    end
    
    def to_ary #:nodoc:
      return self.attributes
    end
    
    def method_missing(method, *args, &block) #:nodoc:
      puts "Missing #{method}"
    end
  end
  
  # Singleton class, that is used globally
  class Helper
    include Singleton
    
    # Recognizing objects retrieved from GitHub, creating new and assigning parameters
    # from YAML
    # === Objects
    # * GitHub::User - recognition by key 'user'
    # More to be added soon
    def self.build_from_yaml(yaml)
      yaml = YAML::load yaml
      object = case
        when yaml.has_key?('user') then [GitHub::User, 'user']
        when yaml.has_key?('users') then [[GitHub::User], 'users']
      end
      if object.first.class == Array
        objects = []
        yaml[object[1]].each do |single_yaml|
          o = object.first.first.new
          o.build single_yaml
          objects << o
        end
        objects
      else
        object[0] = object.first.new
        object.first.build yaml[object[1]]
        object.first
      end
    end
  end
end
