class ActiveRecord::Associations::HasAndBelongsToManyAssociation
  # Short alias for if exists then create
  # @param [ActiveRecord::Base] object An object to check if exists and create
  def find_or_create(object)
    self << object unless exists?(object)
  end
end
