$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'bundler'
Bundler.setup

%w(support).each do |dir|
  Dir.glob(File.expand_path("../#{dir}/**/*.rb", __FILE__), &method(:require))
end

require 'pp'
require 'grape-cache'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
