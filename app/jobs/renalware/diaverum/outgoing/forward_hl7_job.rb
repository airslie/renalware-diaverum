# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      # Forward an HL7 pathology message to Diaverum
      class ForwardHL7Job < ::ApplicationJob
        queue_as :diaverum_outgoing
        queue_with_priority 7 # will wait for any HL7 messages to be processed first

        def perform(transmission:)
          # Could use another forwarding method eg Mirth in the future but for now its just SFTP
          ForwardHL7ToDiaverumViaSFTP.call(transmission)
        end

        def max_attempts
          4
        end

        def destroy_failed_jobs?
          false
        end

        # Reschedule after an error. No point trying straight away, so try at these intervals:
        # After attempt no.  Wait for hours
        # ---------------------------
        # 1                  2
        # 2                  17
        # 3                  82
        # Then give up.
        # Note e.g. attempts**4 == attempts to the power of 4 == 81
        def reschedule_at(current_time, attempts)
          current_time + ((attempts**4) + 1).hours
        end
      end
    end
  end
end
