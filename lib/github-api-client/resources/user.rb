module GitHub
  module Resources
    class User
      @@attributes = {login: :string, name: :string, location: :string, bio: :string, email: :string, hireable: :boolean, blog: :string}
      @@pushables = [:name, :location, :bio, :email, :hireable, :blog]
      @@associations = {repositories: [nil, -> { has_many :repositories, :class_name => 'GitHub::Models::Repository'}]}
      include Resource
    end
  end
end