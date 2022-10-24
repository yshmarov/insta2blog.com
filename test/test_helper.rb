ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # config.before(:example, type: :system) do |_example|
  #   WebMock.allow_net_connect!
  # end
  WebMock.allow_net_connect!
  # WebMock.disable_net_connect!(allow_localhost: true)

  # Add more helper methods to be used by all tests here...
end
