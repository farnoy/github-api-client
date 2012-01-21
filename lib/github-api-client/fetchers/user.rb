module GitHub
  module Fetchers
    module User
      def self.get(login)
        attributes = {}
        model = Models::User.find_by_login(login)
        unless model
          Browser.start do |http|
            request = Net::HTTP::Get.new "/users/#{login}"
            attributes = Fetchers.parse(http.request(request).body)
          end
        else
          # optional, but whatever
          attributes = Resources::User.valid_attributes(model.attributes)
        end
        user = Resources::User.new.tap do |user|
          user.attributes = user.class.valid_attributes(attributes)
        end
        model ||= Models::User.create(user.attributes)
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
