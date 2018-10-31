# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      module Nodes
        # Wraps an incoming DialysisPrescription XML node
        class Prescription < Node
          # We need to use self. here to indicate that eg StartDate (the XML attribute we are
          # shadowing) is a method and not a type
          def valid_start_and_end_dates?
            start_date && end_date
          rescue ArgumentError
            false
          end

          def start_date
            Date.parse(self.StartDate)
          end

          def end_date
            Date.parse(self.EndDate)
          end

          def active?
            today = Time.zone.today
            start_date <= today && end_date >= today
          end
        end
      end
    end
  end
end
