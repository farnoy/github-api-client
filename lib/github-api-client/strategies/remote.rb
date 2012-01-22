module GitHub
  # always refresh
  module Strategies
    module Remote
      class << self
        def should_refresh?(model)
          return true
        end

        def update_strategy(model); end # no need for updating on this strategy
      end
    end
  end
end
