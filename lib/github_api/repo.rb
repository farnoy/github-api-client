module GitHub
  class Repo < ActiveRecord::Base
    belongs_to :owner, :class_name => 'GitHub::User'
    belongs_to :parent, :class_name => 'GitHub::Repo'
    has_and_belongs_to_many :watchers, :class_name => 'GitHub::User', :join_table => 'repo_watchings', :foreign_key => 'repo_id', :association_foreign_key => 'watcher_id'
    
    def get
      self.update_attributes GitHub::Base.parse_attributes(:repo_get, 
        YAML::load(
          GitHub::Browser.get("/repos/show/#{self.permalink}"))['repository'])
      self
    end
    
    def self.get(information)
      #FIXME: permalink column must be present, comparing url's is surely not the most efficient way for the db
      conditions = {:name => information.split('/').last, :owner_id => GitHub::User.find_or_create_by_login(information.split('/').first).id}
      if r = GitHub::Repo.where(conditions).first
        r.get
      else
        r = GitHub::Repo.new(conditions).get
      end
    end
    
    def fetch(*things)
      things.each do |thing|
        case thing
          when :self then get
          when :watchers then get_watchers
        end
      end
      self
    end
    
    private
    def get_watchers
      watchers = YAML::load(GitHub::Browser.get("/repos/show/#{self.permalink}/watchers"))['watchers']
      puts "Fetching watchers for #{"repo".color(:blue).bright} #{self.permalink.color(:green).bright}"
      progress = ProgressBar.new("progress", watchers.count)
      self.transaction do
        watchers.each do |watcher|
          attr = {:login => watcher}
          self.watchers.find_or_create(GitHub::User.find_or_create_by_login(attr))
          progress.inc
        end
      end
      progress.finish
      self
    end
    
    public
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
    
    # For future, when sql will be find_or_create_by_permalink
    def permalink=(anything)
      @permalink = permalink
    end
    
    def fork?
      b_fork
    end
  end
end
