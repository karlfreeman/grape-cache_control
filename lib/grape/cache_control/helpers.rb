module Grape
  module CacheControl
    module Helpers
      def cache_control(*args)
        Grape::CacheControl.cache_control(self, *args)
      end
      def expires(amount, *values)
        Grape::CacheControl.expires(self, amount, *values)
      end
    end
  end
end
