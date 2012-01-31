module GitHub
  module Resources
    class Repository
      @@attributes = {name: :string, description: :string, homepage: :string, private: :boolean, fork: :boolean, language: :string, master_branch: :string, size: :integer, pushed_at: :datetime, created_at: :datetime, has_issues: :boolean, has_wiki: :boolean, has_downloads: :boolean, permalink: :string}
      @@pushables = [:name, :description, :homepage, :private, :has_issues, :has_wiki, :has_downloads] #team_id
      @@associations = {parent: [:parent, -> { belongs_to :parent, :class_name => 'GitHub::Storage::Repository'}],
       contributors: [nil, -> {}], # habtm
       owner: [:owner, -> { belongs_to :owner, class_name: 'GitHub::Storage::User'}]
      }
      include Resource
    end
  end
end
