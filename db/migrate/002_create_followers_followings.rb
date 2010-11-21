class CreateFollowersFollowings < ActiveRecord::Migration
  def self.up
    create_table :followers_followings, :force => true do |t|
      t.references :follower
      t.references :following
    end
  end
  
  def self.down
    drop_table :followers_followings
  end
end
