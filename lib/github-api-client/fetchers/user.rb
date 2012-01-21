module GitHub
  module Fetchers
    module User
      def self.get(login)
        attributes = {}
        Browser.start do |http|
          request = Net::HTTP::Get.new "/users/#{login}"
          attributes = JSON.parse(http.request(request).body, symbolize_names: true)
        end
        return ::GitHub::User.new.tap do |user|
          user.attributes = user.class.valid_attributes(attributes)
        end
      end
    end
  end
end
