require 'active_support/core_ext/hash'

module GitHub
  module Fetchers
    class << self
      def parse(data)
        JSON.parse(data, symbolize_names: true)
      end
    end
  end
end
