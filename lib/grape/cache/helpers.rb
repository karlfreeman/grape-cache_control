module Grape
  module Cache
    module Helpers

      # CACHE_CONTROL = "Cache-Control".freeze
      # SPECIAL_KEYS  = %w[extras no-cache max-age public must-revalidate]
      # DEFAULT_CACHE_CONTROL = "max-age=0, private, must-revalidate".freeze
      # NO_CACHE              = "no-cache".freeze
      # PUBLIC                = "public".freeze
      # PRIVATE               = "private".freeze
      # MUST_REVALIDATE       = "must-revalidate".freeze

        # def cache_control_headers
        #   cache_control = {}

        #   cache_control_segments.each do |segment|
        #     directive, argument = segment.split('=', 2)

        #     if SPECIAL_KEYS.include? directive
        #       key = directive.tr('-', '_')
        #       cache_control[key.to_sym] = argument || true
        #     else
        #       cache_control[:extras] ||= []
        #       cache_control[:extras] << segment
        #     end
        #   end

        #   cache_control
        # end

        # def prepare_cache_control!
        #   @cache_control = cache_control_headers
        #   @etag = self[ETAG]
        # end

        # def handle_conditional_get!
        #   if etag? || last_modified? || !@cache_control.empty?
        #     set_conditional_cache_control!
        #   end
        # end

      def cache_control(*values)
        values_hash = normalize_values(*values)

        cache_control = []
        values_hash.each do |key, value|
          key = key.to_s.tr('_', '-')
          value = value.to_i if key == 'max-age'
          if value.is_a?(TrueClass)
            cache_control << key
          else
            cache_control << "#{key}=#{value}"
          end
        end
        self.header('Cache-Control', cache_control.join(', ')) unless cache_control.empty?
      end

      def expires(amount, *values)
        values_hash = normalize_values(*values)

        if amount.is_a? Integer
          time    = Time.now + amount.to_i
          max_age = amount
        else
          time    = time_for amount
          max_age = time - Time.now
        end

        values_hash.merge!(max_age: max_age)
        cache_control(values_hash)

        self.header('Expires', time.httpdate)
      end


      private

      def normalize_values(*values)
        h = {}
        values.each do |value|
          if value.is_a? Hash
            value.reject! { |k,v| v.is_a?(FalseClass) }
            h.merge!(value)
          elsif value.is_a? Symbol
            h[value] = true
          end
        end
        h
      end

    end
  end
end
