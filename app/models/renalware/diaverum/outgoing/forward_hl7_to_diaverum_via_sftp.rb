# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      class ForwardHl7ToDiaverumViaSftp
        include Diaverum::Logging
        pattr_initialize [:transmission!]

        def call
          save_hl7_file(filename)
        rescue StandardError => error
          log_error(error)
          raise error
        end

        private

        def filename
          Hl7Filename.new(patient: patient).to_s
        end

        def patient
          Renalware::HD::Patient.find(transmission.patient_id)
        end

        def save_hl7_file(filename)
          create_hl7_file_at(Paths.outgoing.join(filename), :out)
          create_hl7_file_at(Paths.outgoing_archive.join(filename), :arc)
        end

        # Write out the HL7 file to a mount from where it will be SFTPed
        # to Diaverum in Sweden
        def create_hl7_file_at(filepath, type)
          File.write(filepath, transmission.payload)
          log_file_sent(filepath, type)
        end

        def diaverum_outgoing_path
          Pathname(Renalware::Diaverum.config.diaverum_outgoing_path)
        end

        def diaverum_outgoing_archive_path
          Pathname(Renalware::Diaverum.config.diaverum_outgoing_archive_path)
        end

        def log_file_sent(filepath, type)
          logger.info("#{type} hl7 #{patient.secure_id} #{patient.local_patient_id} #{filepath}")
          transmission.update(
            transmitted_at: Time.zone.now,
            filepath: filepath
          )
        end

        def log_error(err)
          logger.info("err hl7 #{patient.secure_id} #{patient.local_patient_id} #{err&.message}")
          transmission.update(error: err.message)
        end
      end
    end
  end
end
