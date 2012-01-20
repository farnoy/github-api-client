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
    end
    
    class_variable_get(:@@attributes).each_pair do |key, value|
      method_name = (if value.class == TrueClass then "#{key}?"; else key; end)
      define_method method_name do
        return self.instance_variable_get(:@attributes)[key]
      end
      define_method "#{key}=" do |o|
        p self.methods
        send(:"#{key}_will_change!") unless o == self.instance_variable_get(:@attributes)[key]
        return instance_variable_get(:@attributes)[key] = o
      end if class_variable_get(:@@pushables).include? key
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
