class CreateOrganizationsMembers < ActiveRecord::Migration
  def self.up
    create_table :organizations_members, :id => false do |t|
      t.references :user
      t.references :organization
    end
  end
  
  def self.down
    drop_table :user_followings
  end
end
