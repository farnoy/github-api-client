require 'active_support/concern'
require 'active_model/dirty'

module Resource
  extend ActiveSupport::Concern
  
  included do
    attr_accessor :attributes
    include ActiveModel::Dirty

    define_attribute_methods = class_variable_get(:@@pushables)
    
    define_method :initialize do
      instance_variable_set(:@attributes, {})
			instance_variable_set(:@changed_attributes, {})
    end
    
    class_variable_get(:@@attributes).each_pair do |key, value|
      method_name = (if value.class == TrueClass then "#{key}?"; else key; end)
      define_method method_name do
        return self.instance_variable_get(:@attributes)[key]
      end
      define_method "#{key}=" do |o|
        send(:attribute_will_change!, key) unless o == self.instance_variable_get(:@attributes)[key]
        return instance_variable_get(:@attributes)[key] = o
      end if class_variable_get(:@@pushables).include? key
    end

		define_singleton_method :valid_attributes do |options|
			options.select do |element|
				class_variable_get(:@@attributes).include? element
			end
		end

		class_variable_get(:@@associations).each_pair do |key, value|
			define_method key do
				return ::GitHub::Fetchers.const_get(self.class).send(:"association_#{key}")
			end
		end
    
    define_method :save do
      @changed_attributes.clear
    end
  end

  module ClassMethods
  end

  module InstanceMethods
  end
end
