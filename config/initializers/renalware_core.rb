# frozen_string_literal: true

# Configure the settings for the Renalware::Core engine.

require_dependency "renalware"
require_dependency "renalware/broadcasting"

Renalware.configure do |config|
  # Wire up extra listeners that exists in this engine only and which should receive events
  # raised from within renalware-core. See config/initializers/renalware.rb in the engine for the
  # defaults.
  map = config.broadcast_subscription_map
  subscribers = map["Renalware::Feeds::MessageProcessor"] ||= []
  subscribers << Renalware::Broadcasting::Subscriber.new(
    "Renalware::Diaverum::Outgoing::PathologyListener",
    async: true
  )
end
