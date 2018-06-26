# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      # Find HD Patients dialysing at a particular hospital unit.
      class PatientQuery
        pattr_initialize :local_patient_id

        def self.call(*args)
          new(*args).call
        end

        # Note we inner join onto dialysis_units to make sure we only return patients
        # with an hd_profile.hospital_unit set to a diaverum unit.
        def call
          HD::Patient
            .joins(hd_profile: :hospital_unit)
            .joins("INNER JOIN dialysis_units ON dialysis_units.hospital_unit_id = hospital_units.id")
            .extending(Renalware::ModalityScopes)
            .with_current_modality_matching("HD")
            .find_by(local_patient_id: local_patient_id)
        end
      end
    end
  end
end
