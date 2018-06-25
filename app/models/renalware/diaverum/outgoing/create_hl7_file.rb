# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      class CreateHl7FileFromFeedMessage
        pattr_initialize [:message!]

        def call
          return if patient.nil?
          return unless patient_dialyses_at_a_diaverum_unit?
          DiaverumHl7File.new(patient: patient, message: message).save
        end

        private

        def patient
          @patient ||= begin
            pat = Renalware::Patient.find_by(local_hospital_id: message.patient_identifier)
            logger.warn("Patient not found: #{message.patient_identifier}") if pat.nil?
            pat
          end
        end

        def patient_dialyses_at_a_diaverum_unit?
          # here we really have to check that the patient dialyses at a unit with a code in the
          # of codes we have.
          # So we need to add a configuration class and the client sets it as
          #  config.diaverum_unit_codes = ["THM"]
        end

        class DiaverumHl7File
          pattr_initialize [:patient!, :feed_message!]

          def filename
            # build
          end

          def save
            # File.open...write
          end
        end
      end
    end
  end
end
