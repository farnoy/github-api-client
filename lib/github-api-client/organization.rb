module GitHub
  class Organization < ActiveRecord::Base
    has_and_belongs_to_many :members, :class_name => 'GitHub::User', :join_table => 'organizations_members'
    
    def get
      self.update_attributes(
        GitHub::Base.parse_attributes(:org_get,
          YAML::load(
            GitHub::Browser.get("/organizations/#{self.login}"))['organization']))
      self
    end
    
    def self.get(login)
      o   = GitHub::Organization.find_by_login(login)
      o ||= GitHub::Organization.new(:login => login).get
    end
    
    def fetch(*things)
      things.each do |thing|
        case thing
          when :self then get
          when :members then get_members
        end
      end
      self
    end
    
    private
    def get_members
      members = YAML::load(GitHub::Browser.get "/organizations/#{login}/public_members")['users']
      puts "Fetching members for #{"organization".color(:magenta).bright} #{self.login.color(:green).bright}"
      i, count = 0, members.count.to_s.color(:green).bright
      self.transaction do
        members.each do |user|
          i += 1
          u = GitHub::User.find_or_create_by_login(user['login'])
          self.members.find_or_create u
          print "\r#{i.to_s.color(:yellow).bright}/#{count}"
        end
      end
      puts nil
      self
    end
  end
end
