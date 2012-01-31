module GitHub
  module Fetchers
    module User
      def self.get(login)
        attributes = {}
        model = Storage::User.find_by_login(login)
        should_refresh = model ? Config::Options[:strategy].should_refresh?(model) : true
        if should_refresh
          Browser.start do |http|
            request = Net::HTTP::Get.new "/users/#{login}"
            attributes = Fetchers.parse(http.request(request).body)
            model = Storage::User.find_or_create_by_login(login)
            model.update_attributes(Resources::User.valid_attributes(attributes))
          end
        end
        Resources::User.new.tap do |user|
          user.attributes = model.attributes.symbolize_keys!
        end
      end

      def self.association_repositories(user)
        attributes = {}
        models = (um = Storage::User.find_by_name(user.name)) ? um.repositories : []
        should_refresh = models.empty? ? true : Config::Options[:strategy].should_refresh?(models)
        if should_refresh
          models = [] # ensure empty when refreshing
          Browser.start do |http|
            request = Net::HTTP::Get.new "/users/#{user.login}/repos"
            attributes = Fetchers.parse(http.request(request).body)
          end

          ActiveRecord::Base.transaction do
            attributes.each do |repo|
              permalink = repo[:owner][:login] + '/' + repo[:name]
              models << Storage::Repository.find_or_create_by_permalink(permalink)
              models.last.update_attributes(Resources::Repository.valid_attributes(repo))
            end
          end
        end
        collection = []
        models.each do |model|
          collection << Resources::Repository.new.tap do |repo|
            repo.attributes = Resources::Repository.valid_attributes(model.attributes.symbolize_keys!)
          end
        end
        return collection
      end
    end
  end
end
