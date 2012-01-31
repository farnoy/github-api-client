require 'active_support/concern'
require 'active_model/dirty'
require 'active_support/core_ext/string'

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
      method_name = (if value == :boolean then "#{key}?"; else key; end)
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
        class_variable_get(:@@attributes).include?(element) or element == :id
      end
    end

    class_variable_get(:@@associations).each_pair do |key, value|
      define_method key do
        return GitHub::Fetchers.const_get(GitHub::Helpers.const_name(self)).send(:"association_#{key}", self)
      end
    end
    
    define_method :save do
      @changed_attributes.clear
    end

    define_method :model do
      GitHub::Helpers.const_at(GitHub::Helpers.const_name(self), GitHub::Storage).find(instance_variable_get(:@attributes)[:id])
    end

    define_method :inspect do
      s = "#<Resource:#{self.class.to_s.split('::').last}"
      instance_variable_get(:@attributes).each do |key, value|
        value = "\"#{value.truncate(20, separator: ' ')}\"" if value.is_a? String
        if not value.to_s.empty? and not (key == :id)
          s += " #{key}: #{value}"
          s += "," unless key == instance_variable_get(:@attributes).keys.last
        end
      end
      s += ">"
    end

    # Create ActiveRecord model (for storing locally)
    GitHub.const_set :Storage, Module.new unless GitHub.const_defined? :Storage
    const_name = self.name.to_s.split('::').last.to_sym
    klass = GitHub::Storage.const_set const_name, (Class.new(ActiveRecord::Base))
    klass.class_exec do
      GitHub::Resources.const_get(const_name).class_variable_get(:@@associations).each_pair do |key, value|
        self.class_exec &value.last
      end
    end
  end
end
