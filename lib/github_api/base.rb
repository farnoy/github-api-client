module GitHub
  # Basic functionality inherited later
  class Base
    # Sends key= value signals at object, that inherits it
    # @param [Hash] options to assign for an object
    def build(options = {})
      options.each_pair do |k, v|
        self.send "#{k.to_sym}=", v
      end
    end
    
    # Synchronizes every information from local database with GitHub
    # == VERY DANGEROUS AND EVIL
    # Recursively gets all* GitHub Users, takes years to fetch
    # * - all that have at least one follower
    # @return nil
    def self.sync
      puts "Synchronizing local database with GitHub"
      users = GitHub::User.all
      count = users.count
      i = 1
      users.each do |user|
        puts "#{count.to_s.color(:green).bright} / #{i.to_s.color(:blue).bright} - Updating records"
        i = i + 1
        # Disabled because of its length
        #user.get
        #user.get_followers
      end
      nil
    end
     
    # Converts pitfalls from GitHub API differences into normal data
    # @param [Symbol] resource GitHub Resource to parse
    # @option [Symbol] resource :user Parse attributes of User
    # @option [Symbol] resource :repo Parse attributes of Repo
    # @param [Hash] attributes GitHub API retrieved attributes to be parsed
    # @return [Hash] parsed attributes, fully compatibile with local db
    def self.parse_attributes(resource, attributes)
      hash = case resource
        when :user_get then {:public_repo_count => :nil, :public_gist_count => :nil, :created => :nil, :permission => :nil, :followers_count => :nil, :following_count => :nil}
        when :user_search then {:name => :login, :username => :login, :fullname => :name, :followers => :nil, :repos => :public_repo_count, :created => :nil, :permission => :nil}
        when :repo_get then {:fork => :b_fork}
      end
      hash.each do |k, v|
        unless v == :nil
          if [:repo_get].include? resource
            attributes[v.to_s] = attributes[k.to_sym]
          else
            attributes[v.to_s] = attributes[k.to_s]
          end
        end
        if [:repo_get].include? resource
          attributes.delete k.to_sym
        else
          attributes.delete k.to_s
        end
      end
      p attributes
      attributes
    end
    
    # ActiveRecord fix that returns attributes
    # @return [Hash] Attributes of the object
    def to_ary
      return self.attributes
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
    # @deprecated Nothing uses it, but may come handy later
    # @param [String] yaml a YAML content to be parsed
    # @return [GitHub::User, Array]
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
