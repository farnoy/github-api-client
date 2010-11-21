class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      %w(login token type name company location blog email fullname language username).each do |attr|
        t.string attr
      end
      
      %w(gravatar_id public_repo_count public_gist_count following_count followers_count followers score record repos).each do |attr|
        t.integer attr
      end
      
      %w(created_at pushed created).each do |attr|
        t.datetime attr
      end
    end
  end
  
  def self.down
    drop_table :users
  end
end
