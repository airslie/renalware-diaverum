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

      config_accessor(:diaverum_incoming_skip_session_save) do
        ENV.fetch("DIAVERUM_INCOMING_SKIP_SESSION_SAVE", true).to_s != "false"
      end

      config_accessor(:diaverum_go_live_date) do
        Date.parse(ENV.fetch("DIAVERUM_GO_LIVE_DATE") { "2018-11-07" })
      end

      config_accessor(:honour_treatment_deleted_flag) do
        Date.parse(ENV.fetch("HONOUR_TREATMENT_DELETED_FLAG") { "true" })
      end
    end

    def self.config
      @config ||= Configuration.new
    end

    # Used in tests only! See ConfigurationHelpers
    def self.reset_config
      @config = nil
    end

    def self.configure
      yield config
    end
  end
end
