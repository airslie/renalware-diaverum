# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      # Find HD Patients dialysing at a particular hospital unit.
      class PatientQuery
        pattr_initialize [:nhs_number!, :hosp_no!]

        def self.call(**args)
          new(**args).call
        end

        def self.diaverum_patients
          HD::Patient
            .joins(:hd_profile)
            .where("hospital_unit_id in (?)", diaverum_hospital_unit_ids)
            .extending(Renalware::ModalityScopes)
            .with_current_modality_matching("HD")
        end

        # Get ids of all hospitral units that are configured to be be unit where
        # Diaverum HD machines are used.
        def self.diaverum_hospital_unit_ids
          hospital_unit_ids = HD::ProviderUnit.all
            .joins(:hd_provider)
            .where("hd_providers.name ilike ?", "%Diaverum%")
            .map(&:hospital_unit_id)
          Hospitals::Unit.where(id: hospital_unit_ids).pluck(:id)
        end

        # Note we inner join onto dialysis_units to make sure we only return patients
        # with an hd_profile.hospital_unit set to a diaverum unit.
        def call
          return if nhs_number.blank? && hosp_no.blank?

          self.class.diaverum_patients
            .where("nhs_number = ? or local_patient_id = ?", nhs_number, hosp_no)
            .first
        end
      end
    end
  end
end
