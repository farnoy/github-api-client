class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      %w(login token type name company location blog email language permission).each do |attr|
        t.string attr
      end
      
      %w(gravatar_id score record).each do |attr|
        t.integer attr
      end
      
      %w(created_at pushed).each do |attr|
        t.datetime attr
      end
    end
  end
  
  def self.down
    drop_table :users
  end
end
