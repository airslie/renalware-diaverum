# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      # Base class for e.g. DNASessionBuilder
      class SessionBuilder
        attr_reader :patient, :treatment_node, :user

        def self.call(**args)
          new(**args).call
        end

        def initialize(patient:, treatment_node:, user:)
          @patient = patient
          @treatment_node = treatment_node
          @user = user
        end

        protected

        def hospital_unit
          dialysis_unit.hospital_unit
        end

        def dialysis_unit
          HD::ProviderUnit.find_by!(providers_reference: treatment_node.ClinicId)
        end

        def dialysate
          raise Errors::DialysateMissingError if treatment_node.Dialysate.blank?

          Renalware::HD::Dialysate.find_by!(name: treatment_node.Dialysate)
        rescue ActiveRecord::RecordNotFound
          raise Errors::DialysateNotFoundError, treatment_node.Dialysate
        end

        def access_type
          AccessMap.for(
            diaverum_location: treatment_node.AccessLocationId,
            diaverum_type: treatment_node.AccessTypeId
          )
        end

        def hd_type
          HDTypeMap.for(diaverum_type_id: treatment_node.TypeId)
        end

        def most_recent_dry_weight
          Renalware::Clinical::DryWeight
            .for_patient(patient)
            .order(assessed_on: :desc)
            .first
        end
      end
    end
  end
end
