class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      %w(name company location blog type login email gravatar_id billing_email permission).each do |attr|
        t.string attr
      end
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :organizations
  end
end
