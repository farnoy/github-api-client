class CreateFollowings < ActiveRecord::Migration
  def self.up
    create_table :followings, :id => false, :force => true do |t|
      t.references :follower
      t.references :following
    end
  end
  
  def self.down
    drop_table :followings
  end
end
