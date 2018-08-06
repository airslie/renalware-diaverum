# frozen_string_literal: true

# Class for configuring the Renalware::Diaverum engine
#
# To override default config values, create an initializer in the host application
# e.g. config/initializers/renalware_diaverum.rb, and use e.g.:
#
#   Renalware::Diaverum.configure do |config|
#    config.x = y
#    ...
#   end
#
# To access configuration settings use e.g.
#   Renalware::Diaverum.config.x
#
module Renalware
  module Diaverum
    class Configuration
      include ActiveSupport::Configurable

      # Force dotenv to load the .env file at this stage so we can read in the config defaults
      Dotenv::Railtie.load

      # config_accessor(:diaverum_outgoing_path) { ENV["DIAVERUM_OUTGOING_PATH"] }
      # config_accessor(:diaverum_outgoing_archive_path) { ENV["DIAVERUM_OUTGOING_ARCHIVE_PATH"] }
      # config_accessor(:diaverum_incoming_path) { ENV["DIAVERUM_INCOMING_PATH"] }
      # config_accessor(:diaverum_incoming_archive_path) { ENV["DIAVERUM_INCOMING_ARCHIVE_PATH"] }
      # config_accessor(:diaverum_incoming_error_path) { ENV["DIAVERUM_INCOMING_ARCHIVE_PATH"] }
    end

    def self.config
      @config ||= Configuration.new
    end

    def self.configure
      yield config
    end
  end
end
