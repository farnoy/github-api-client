module GitHub
  module Fetchers
    module Repository
      class << self
        def get(permalink)
          attributes = {}
          name = permalink.split('/').last
          owner = Models::User.find_by_login(permalink.split('/').first)
          model = owner.repositories.find_by_name(name) if owner
          model ||= nil
          should_refresh = (if model then Config::Options[:strategy].should_refresh?(model); else false; end) # refactor
          if not model or should_refresh
            Browser.start do |http|
              request = Net::HTTP::Get.new "/repos/#{permalink}"
              attributes = Fetchers.parse(http.request(request).body)
              model = Models::Repository.find_or_create_by_permalink(permalink)
              model.update_attributes(Resources::Repository.valid_attributes(attributes))
            end
          end
          repo = Resources::Repository.new.tap do |repo|
            repo.attributes = Resources::Repository.valid_attributes(model.attributes.symbolize_keys)
          end
        end
      end
    end
  end
end
