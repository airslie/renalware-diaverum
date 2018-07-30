# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      # Find HD Patients dialysing at a particular hospital unit.
      class PatientQuery
        pattr_initialize [:local_patient_id!]

        def self.call(*args)
          new(*args).call
        end

        # Note we inner join onto dialysis_units to make sure we only return patients
        # with an hd_profile.hospital_unit set to a diaverum unit.
        def call
          HD::Patient
            .joins(:hd_profile)
            .where(hospital_unit_id: diaverum_hospital_unit_ids)
            .extending(Renalware::ModalityScopes)
            .with_current_modality_matching("HD")
            .find_by(local_patient_id: local_patient_id)
        end

        private

        def diaverum_hospital_unit_ids
          hospital_unit_ids = HD::ProviderUnit.all
            .joins(:hd_provider)
            .where("hd_providers.name ilike ?", "%Diaverum%").map(&:id)
          Hospitals::Unit.where(id: hospital_unit_ids).pluck(:id)
        end
      end
    end
  end
end
