# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      module SessionBuilders
        # Given a Diaverum HD Treatment XML node and a patient, build a new,
        # unsaved HD::Session::DNA object by mapping diaverum attributes to Renalware ones.
        class DNA < Base
          def call
            assign_top_level_attributes
            build_notes
            session
          end

          private

          def session
            @session ||= Renalware::HD::Session::DNA.new
          end

          # rubocop:disable Metrics/AbcSize
          def assign_top_level_attributes
            session.assign_attributes(
              patient: patient,
              hospital_unit: hospital_unit,
              performed_on: treatment_node.Date,
              notes: treatment_node.Notes,
              created_by: user,
              updated_by: user,
              signed_on_by: user,
              signed_off_by: user,
              external_id: treatment_node.TreatmentId
            )

            session.document.patient_on_holiday = :no
          end
          # rubocop:enable Metrics/AbcSize
        end
      end
    end
  end
end
