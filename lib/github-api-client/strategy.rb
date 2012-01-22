module GitHub
  class CachingStrategyNotImplemented < StandardError; end
  # Template
  module CachingStrategy
    class << self
      def should_refresh?(model)
        throw CachingStrategyNotImplemented
      end
  
      def update_strategy(model)
        throw CachingStrategyNotImplemented
      end
    end
  end
end
