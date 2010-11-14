class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string :login
      t.string :token
    end
  end
  
  def self.down
    drop_table :users
  end
end
