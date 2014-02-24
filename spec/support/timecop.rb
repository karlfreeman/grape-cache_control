require 'timecop'
RSpec.configure do |config|
  config.before(:each) do
    Timecop.freeze
  end
  config.after(:each) do
    Timecop.return
  end
end