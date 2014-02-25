require 'grape'
require 'grape/cache_control/version'

module Grape
  module CacheControl
    autoload :Helpers, 'grape/cache_control/helpers'
    Grape::Endpoint.send :include, Grape::CacheControl::Helpers

    CACHE_CONTROL         = 'Cache-Control'.freeze
    EXPIRES               = 'Expires'.freeze
    TRUE                  = 'true'.freeze
    SETTABLE_DIRECTIVES   = [:max_age, :s_maxage].freeze
    TRUTHY_DIRECTIVES     = [:public, :private, :no_cache, :no_store, :no_transform, :must_revalidate, :proxy_revalidate].freeze
    ALL_DIRECTIVES        = (TRUTHY_DIRECTIVES | SETTABLE_DIRECTIVES).freeze

    ALL_DIRECTIVES.each do |d|
      const_set(d.upcase, d.to_s.tr('_', '-'))
    end

    class << self
      def cache_control(request, *values)
        cc_directives = {}

        (cache_control_segments(request.header(CACHE_CONTROL)) | cache_control_values(*values)).each do |segment|
          directive, argument = segment.split('=', 2)
          cc_directives[directive.tr('-', '_').to_sym] = argument || true
        end

        if !cc_directives.empty?
          cc_header = []
          cc_directives.delete(:public) if cc_directives.key? :private
          cc_directives.delete(:private) if cc_directives.key? :public
          cc_directives.each do |k, v|
            if SETTABLE_DIRECTIVES.include?(k)
              cc_header << "#{Grape::CacheControl.const_get(k.upcase)}=#{v.to_i}"
            elsif TRUTHY_DIRECTIVES.include?(k) && v == TRUE
              cc_header << Grape::CacheControl.const_get(k.upcase)
            end
          end
          request.header(CACHE_CONTROL, cc_header.join(', '))
        end
      end

      def expires(request, amount, *values)
        if amount.is_a? Integer
          time    = Time.now + amount.to_i
          max_age = amount
        else
          time    = amount
          max_age = time - Time.now
        end

        values << { max_age: max_age }
        request.header(EXPIRES, time.httpdate)
        cache_control(request, *values)
      end

      private

      def cache_control_values(*values)
        cache_control_values = []
        values.each do |value|
          if value.is_a? Hash
            cache_control_values.concat value.map { |k, v|
              argument = v.is_a?(Time) ? v - Time.now : v
              "#{Grape::CacheControl.const_get(k.upcase)}=#{argument}"
            }
          elsif value.is_a? Symbol
            cache_control_values << "#{value}=#{TRUE}"
          end
        end
        cache_control_values
      end

      def cache_control_segments(header = nil)
        segments = []
        segments.concat header.delete(' ').split(',') unless header.nil?
        segments
      end
    end
  end
end
