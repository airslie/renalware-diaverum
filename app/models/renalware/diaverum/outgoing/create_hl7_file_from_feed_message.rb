# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      class CreateHl7FileFromFeedMessage
        pattr_initialize [:message!, :logger!]

        def call
          return if patient.nil?
          return unless patient_dialyses_at_a_diaverum_unit?
          filename = Hl7Filename.new(patient: patient, message: message).to_s
          save_hl7_file(filename)
        end

        private

        def patient
          @patient ||= begin
            pat = Renalware::HD::Patient.find_by(local_patient_id: message.patient_identifier)
            logger.warn("Patient not found: #{message.patient_identifier}") if pat.nil?
            pat
          end
        end

        def patient_dialyses_at_a_diaverum_unit?
          diaverum_unit_ids.include?(patient.hd_profile&.hospital_unit&.id)
        end

        # We configure which units are Diaverum units in the diaverum.dialysis_units table
        def diaverum_unit_ids
          Diaverum::DialysisUnit.pluck(:hospital_unit_id)
        end

        def save_hl7_file(filename)
          filepath = diaverum_outgoing_path.join(filename)
          archive_filepath = diaverum_outgoing_archive_path.join(filename)
          File.write(filepath, message.body)
          File.write(archive_filepath, message.body)
          logger.info("#{message.patient_identifier}: sent HL7 file #{filename}")
          true
        end

        def diaverum_outgoing_path
          Pathname(Renalware::Diaverum.config.diaverum_outgoing_path)
        end

        def diaverum_outgoing_archive_path
          Pathname(Renalware::Diaverum.config.diaverum_outgoing_archive_path)
        end

        # class DiaverumHl7File
        #   pattr_initialize [:patient!, :feed_message!]

        #   def filename
        #     # build
        #   end

        #   def save
        #     # File.open...write
        #   end
        # end
      end
    end
  end
end
