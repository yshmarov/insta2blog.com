ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'
require 'passwordless/test_helpers'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  WebMock.allow_net_connect! # required for running system tests in CI
  # WebMock.disable_net_connect!(allow_localhost: true) # required for not running real requests in test env (enforce stub)

  # Add more helper methods to be used by all tests here...
  if defined?(ActionDispatch::IntegrationTest)
    ActiveSupport.on_load(:action_dispatch_integration_test) do
      include ::Passwordless::TestHelpers::RequestTestCase
    end
  end
end
