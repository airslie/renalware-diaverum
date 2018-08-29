# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      class Hl7Filename
        pattr_initialize [:patient!]

        def to_s
          timestamp = Time.zone.now.strftime("%Y%m%d%H%M%S%L")
          dob = patient.born_on&.strftime("%Y%m%d")
          "#{timestamp}_#{patient.nhs_number}_#{patient.local_patient_id&.upcase}_#{dob}.hl7"
        end
      end
    end
  end
end
