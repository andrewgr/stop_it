require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'stop_it'

RSpec.configure do |config|
  config.mock_with :rspec
end
