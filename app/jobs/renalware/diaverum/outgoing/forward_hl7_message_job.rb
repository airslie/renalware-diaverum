# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      # Forward an HL7 pathology message to Diaverum
      class ForwardHl7MessageJob < ::ApplicationJob
        # feed_message is a Renalware::Feeds::Message instance.
        # patient is an Renalware::Patient
        def perform(feed_message:, patient:, transmission_log:)
          CreateHl7FileFromFeedMessage.new(
            message: feed_message,
            patient: patient,
            transmission_log: transmission_log
          ).call
        end
      end
    end
  end
end
