require 'grape'
require 'grape/cache/version'

module Grape
  module Cache
    autoload :Extensions, 'grape/cache/extensions'
    autoload :Helpers, 'grape/cache/helpers'
    Grape::API.send :extend, Grape::Cache::Extensions
    Grape::Endpoint.send :include, Grape::Cache::Helpers
  end
end