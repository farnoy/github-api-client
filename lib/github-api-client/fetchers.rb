require 'active_support/core_ext/hash'

module GitHub
  module Fetchers
    class << self
      def parse(data)
        JSON.parse(data, symbolize_names: true)
      end
    end

    module Helpers
      class << self
        def const_at(sym, scope)
          throw ArgumentError, "first parameter must be a symbol" unless sym.is_a? Symbol
          throw ArgumentError, "scope must be a module" unless scope.is_a? Module
          return scope.const_get(sym)
        end

        def const_name(object)
          return object.class.name.split('::').last.to_sym
        end
      end
    end
  end
end
