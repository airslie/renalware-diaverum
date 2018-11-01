# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      class ResolveDialysateFlowRate
        pattr_initialize [:patient!, :patient_node!, :treatment_node!]

        def call
          treatment_node.DialysateFlow.presence ||
            patient_node.current_dialysis_prescription&.DialysateFlow.presence ||
            dialysate_flow_rate_from_hd_profile
        end

        private

        def dialysate_flow_rate_from_hd_profile
          HD::Profile.for_patient(patient)&.document&.dialysis&.flow_rate
        end
      end
    end
  end
end
