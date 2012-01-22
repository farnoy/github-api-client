module GitHub
  module Fetchers
    module User
      def self.get(login)
        attributes = {}
        model = Models::User.find_by_login(login)
        should_refresh = (if model then Config::Options[:strategy].should_refresh?(model); else false; end)
        if not model or should_refresh
          Browser.start do |http|
            request = Net::HTTP::Get.new "/users/#{login}"
            attributes = Fetchers.parse(http.request(request).body)
            model = Models::User.find_or_create_by_login(login)
            model.update_attributes(Resources::User.valid_attributes(attributes))
          end
        end
        user = Resources::User.new.tap do |user|
          user.attributes = user.class.valid_attributes(attributes)
        end
        return model
      end

      def self.association_repositories(user)
        attributes = {}
        Browser.start do |http|
          request = Net::HTTP::Get.new "/users/#{user.login}/repos"
          attributes = Fetchers.parse(http.request(request).body)
        end
        # further iterate and create Resources::Repository
      end
    end
  end
end
