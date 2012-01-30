module GitHub
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
