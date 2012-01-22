module GitHub
  # always refresh
  module Strategies
    module Local
      class << self
        def should_refresh?(model)
          return false
        end

        def update_strategy(model); end # no need for updating on this strategy
      end
    end
  end
end
