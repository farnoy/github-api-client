class CreateRepoWatchings < ActiveRecord::Migration
  def self.up
    create_table :repo_watchings, :id => false do |t|
      t.references :watcher
      t.references :repo
    end
  end
  
  def self.down
    drop_table :repo_watchings
  end
end
