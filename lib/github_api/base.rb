module GitHub
  class Base
    def build(options = {})
      options.each_pair do |k, v|
        self.send :"#{k.to_sym}=", v
      end
    end
    
    def method_missing(method, *args, &block)
      puts "Missing #{method}"
    end
  end
end
