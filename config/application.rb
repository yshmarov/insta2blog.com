require_relative "boot"

require "rails/all"
require 'good_job/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Insta2blog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.active_job.queue_adapter = :good_job
    if Rails.env.production?
      config.middleware.use Rack::HostRedirect, {
        "www.insta2blog.com" => "insta2blog.com",
        "insta2blog.herokuapp.com" => "insta2blog.com"
      }
    end
  end
end
