class CreateOrganizationsRepos < ActiveRecord::Migration
  def self.up
    create_table :organizations_repos, :id => false do |t|
      t.references :organization
      t.references :repo
    end
  end
  
  def self.down
    drop_table :organizations_repos
  end
end
