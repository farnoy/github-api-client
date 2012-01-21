module GitHub
	module Fetchers
		module User
			def self.get(login)
				attributes = {}
				Browser.start do |http|
					request = Net::HTTP::Get.new "/users/#{login}"
					attributes = JSON.parse(http.request(request).body, symbolize_names: true)
				end
				attributes = attributes.select do |key, value|
					::GitHub::User.class_variable_get(:@@attributes).include? key
				end
				return ::GitHub::User.new.tap {|o| o.attributes=(attributes) }
			end
		end
	end
end
