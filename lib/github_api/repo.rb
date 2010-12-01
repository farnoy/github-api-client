module GitHub
  class Repo < ActiveRecord::Base
    belongs_to :owner, :class_name => 'GitHub::User'
    belongs_to :parent, :class_name => 'GitHub::Repo'
    
    def self.get(information)
      GitHub::Repo.find_or_create_by_id(GitHub::Base.parse_attributes(:repo, YAML::load(GitHub::Browser.get("/repos/show/#{information}"))['repository']))
    end
    
    
    def owner=(user)
      self.owner_id = GitHub::User.find_or_create_by_login(user).id if user.class == String
      if user.class == GitHub::User
        self.owner_id = user.id
      end
    end
    
    def parent=(permalink)
      owner = GitHub::User.find_or_create_by_login permalink.split('/').first
      name = permalink.split('/').last
      repo = GitHub::Repo.where(:owner_id => owner.id, :name => name).first
      repo ||= GitHub::Repo.create(:owner_id => owner.id, :name => name)
      self.parent_id = repo.id
    end
    
    def permalink
      "#{owner.login}/#{name}"
    end
  end
end
