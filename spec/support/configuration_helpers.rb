# frozen_string_literal: true

module Renalware
  module Diaverum
    module ConfigurationHelpers
      def with_modified_env(options)
        ClimateControl.modify(options) do
          reset_config
          yield
        end
      end

      def reset_config
        Diaverum.reset_config
        load Diaverum::Engine.root.join("lib/renalware/diaverum/configuration.rb")
      end
    end
  end
end
