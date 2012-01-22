module GitHub
  module Strategies
    module Ask
      class << self
        def should_refresh?(model)
          puts "Should I refresh #{Fetchers::Helpers.const_name(model)}? [y/n]"
          return gets.chomp == 'y'
        end

        def update_strategy(model); end # no need for updating on this strategy
      end
    end
  end
end
