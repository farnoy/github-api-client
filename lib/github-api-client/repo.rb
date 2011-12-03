module GitHub
  class Repo < ActiveRecord::Base
    belongs_to :owner, :polymorphic => true
    belongs_to :parent, :class_name => 'GitHub::Repo'
    has_and_belongs_to_many :watchers, :class_name => 'GitHub::User', :join_table => 'repo_watchings', :foreign_key => 'repo_id', :association_foreign_key => 'watcher_id'
    
    def get
      parser = case self.owner_type
        when 'GitHub::User'
          :repo_get
        when 'GitHub::Organization'
          :org_repo_get
      end
      self.update_attributes GitHub::Base.parse_attributes(parser, 
        YAML::load(
          GitHub::Browser.get("/repos/show/#{self.permalink}"))['repository'])
      self
    end
    
    def self.get(information, o_type = :user)
      #FIXME: permalink column must be present, comparing url's is surely not the most efficient way for the db
      conditions = {:name => information.split('/').last}
      if o_type == :user
        conditions.merge! :owner_id => GitHub::User.find_or_create_by_login(information.split('/').first).id, :owner_type => 'GitHub::User'
      else
        conditions.merge! :owner_id => GitHub::Organization.find_or_create_by_login(information.split('/').first).id, :owner_type => 'GitHub::Organization'
      end
      if r = GitHub::Repo.where(conditions).first
        r.get
      else
        r = GitHub::Repo.new(conditions).get
        p r.parent
        r
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
      puts "Fetching watchers for #{"repo".color(:blue).bright} #{self.permalink.dup.color(:green).bright}"
      i, count = 0, watchers.count.to_s.color(:green).bright
      self.transaction do
        watchers.each do |watcher|
          i += 1
          attr = {:login => watcher}
          self.watchers.find_or_create(GitHub::User.find_or_create_by_login(attr))
          print "\r#{i.to_s.color(:blue).bright}/#{count}"
        end
      end
      puts nil
      self
    end
    
    public
    def owner_login=(user)
      if user
        self.owner = GitHub::User.find_or_create_by_login(user)
      end
    end
    
    def organization_login=(organization)
      if organization
        self.owner = Organization.find_or_create_by_login(organization)
      end
    end
    
    def parent=(permalink)
      #FIXME: parent repo does not allow organization to be owner ATM
      owner = GitHub::User.find_or_create_by_login permalink.split('/').first
      name = permalink.split('/').last
      repo = GitHub::Repo.where(:owner_id => owner.id, :owner_type => 'GitHub::Repo', :name => name).first
      repo ||= GitHub::Repo.create(:owner => owner, :name => name)
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
