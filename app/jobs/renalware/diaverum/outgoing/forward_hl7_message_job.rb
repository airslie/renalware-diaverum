# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      # Forward an HL7 pathology message to

      class ForwardHl7MessageJob < ::ApplicationJob

        # Message is a Feeds::Message instance.
        def perform(feed_message)
          # 1. Get the patient using message.patient_identifier and assume its
          #    a local_hospital_id - TEST
          # 2a.Format a filename - TEST
          # 2b.Create a file, add message.body to it, and drop it into the diaverum out
          #    folder - TEST
          # 3. Log what happened to log/diaverum.log - TEST
          # 4. Make sure we can handle a retry without duplication - TEST

          CreateHl7FileFromFeedMessage.new(feed_message, logger).call
        end
      end
    end
  end
end
