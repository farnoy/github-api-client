module GitHub
  class Base
    def build(options = {})
      options.each_pair do |k, v|
        self.send ("#{k.to_sym}=").to_sym, v
      end
    end
  end
end
