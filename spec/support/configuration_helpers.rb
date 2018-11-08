# frozen_string_literal: true

module Renalware
  module Diaverum
    module ConfigurationHelpers
      # options is a hash of ENV vars e.g. { X: "y" } that we are going to temporarily use to
      # override the existing ENV vars supplied by Dotenv.
      # We reinstate the Dotenv ENV vars before returning.
      def with_modified_env(options)
        ClimateControl.modify(options) do
          reload_config_singleton
          yield
        end
      ensure
        revert_to_using_dotenv_vars
      end

      def reload_config_singleton
        Diaverum.reset_config
        load Diaverum::Engine.root.join("lib/renalware/diaverum/configuration.rb")
      end

      def revert_to_using_dotenv_vars
        Dotenv::Railtie.load
        reload_config_singleton
      end
    end
  end
end
