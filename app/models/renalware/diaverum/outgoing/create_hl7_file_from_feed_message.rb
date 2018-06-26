# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      class CreateHl7FileFromFeedMessage
        include Diaverum::Logging
        pattr_initialize [:message!, :patient!]

        def call
          save_hl7_file(filename)
        rescue StandardError => error
          log_error(error)
          raise error
        end

        private

        def filename
          Hl7Filename.new(patient: patient, message: message).to_s
        end

        def save_hl7_file(filename)
          filepath = diaverum_outgoing_path.join(filename)
          archive_filepath = diaverum_outgoing_archive_path.join(filename)
          File.write(filepath, message.body)
          log_file_sent(filepath, :out)
          File.write(archive_filepath, message.body)
          log_file_sent(archive_filepath, :arc)
          true
        end

        def diaverum_outgoing_path
          Pathname(Renalware::Diaverum.config.diaverum_outgoing_path)
        end

        def diaverum_outgoing_archive_path
          Pathname(Renalware::Diaverum.config.diaverum_outgoing_archive_path)
        end

        def log_file_sent(filepath, type)
          logger.info("#{type} hl7 #{patient.secure_id} #{patient.local_patient_id} #{filepath}")
        end

        def log_error(err)
          logger.info("err hl7 #{patient.secure_id} #{patient.local_patient_id} #{err&.message}")
        end
      end
    end
  end
end
