module GitHub
  module Resources
    class User
      @@attributes = {login: :string, name: :string, location: :string, bio: :string, email: :string, hireable: :boolean, blog: :string}
      @@pushables = [:name, :location, :bio, :email, :hireable, :blog, :company]
      @@associations = {repositories: [nil, -> { has_many :repositories, class_name: 'GitHub::Models::Repository', foreign_key: :owner_id}]}
      include Resource
    end
  end
end
