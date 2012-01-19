puts "EXECUTING"
ActiveRecord::Associations::HasAndBelongsToManyAssociation.class_eval do
  # Short alias for if exists then create
  # @param [ActiveRecord::Base] object An object to check if exists and create
  def find_or_create(object)
    self.concat(object) unless include?(object)
  end
end
