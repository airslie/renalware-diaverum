# frozen_string_literal: true

require_relative "boot"

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)
require "renalware/diaverum"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.cache_store = :file_store, Rails.root.join("tmp", "cache") # capistrano symmlinked
    config.active_record.time_zone_aware_types = [:datetime]
    config.active_record.dump_schemas = :all
    config.exceptions_app = Renalware::Engine.routes
    config.active_job.queue_adapter = :delayed_job
    config.time_zone = "London"
    # :sql required because we use pg features unsupported in a schema.rb
    config.active_record.schema_format = :sql

    initializer :add_locales do
      config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    end
  end
end
