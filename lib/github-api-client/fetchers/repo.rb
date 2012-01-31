module GitHub
  module Fetchers
    module Repository
      class << self
        def get(permalink)
          attributes = {}
          name = permalink.split('/').last
          owner = Models::User.find_or_create_by_login(permalink.split('/').first)
          model = owner.repositories.find_by_name(name)
          model ||= nil
          should_refresh = model ? Config::Options[:strategy].should_refresh?(model) : true
          if should_refresh
            Browser.start do |http|
              request = Net::HTTP::Get.new "/repos/#{permalink}"
              attributes = Fetchers.parse(http.request(request).body)
              model = Models::Repository.find_or_create_by_permalink(permalink)
              model.owner = owner
              model.update_attributes(Resources::Repository.valid_attributes(attributes))
            end
          end
          repo = Resources::Repository.new.tap do |repo|
            repo.attributes = Resources::Repository.valid_attributes(model.attributes.symbolize_keys)
          end
        end

        def association_owner(repo)
          User.get(repo.model.owner.login) # requires #get function to associate owner *always*
        end
      end
    end
  end
end
