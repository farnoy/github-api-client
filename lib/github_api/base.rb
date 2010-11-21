module GitHub
  class Base
    def build(options = {})
      options.each_pair do |k, v|
        self.send "#{k.to_sym}=", v
      end
    end
    
    def to_ary
      return self.attributes
    end
    
    def method_missing(method, *args, &block)
      puts "Missing #{method}"
    end
  end
  
  class Helper
    include Singleton
    
    def self.build_from_yaml(yaml)
      yaml = YAML::load yaml
      object = case
        when yaml.has_key?('user') then [GitHub::User, 'user']
      end
      object[0] = object.first.new
      object.first.build yaml[object[1]]
      
      object.first
    end
  end
end
