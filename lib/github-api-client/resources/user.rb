module GitHub
  module Resources
    class User
      @@attributes = {login: String, name: String, has_repos: true, location: String, bio: String, email: String, hireable: true, blog: String}
      @@pushables = [:name, :location, :bio, :email, :hireable, :blog]
      @@associations = {repositories: [nil, -> { has_many :repositories, :class_name => Repo}]}
      include Resource
    end
  end
end
