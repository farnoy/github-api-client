class CreateUserFollowings < ActiveRecord::Migration
  def self.up
    create_table :user_followings, :id => false, :force => true do |t|
      t.references :follower
      t.references :following
    end
  end
  
  def self.down
    drop_table :user_followings
  end
end
