# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      # At this point we assume the following:
      # - we have been passed a Feeds::Message and the patient associated with the message
      # - the patient dialyses at a Diaverum site.
      # See PathologyListener for that logic
      class CreateHl7FileFromFeedMessage
        include Diaverum::Logging
        pattr_initialize [:message!, :patient!, :transmission_log!]

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

        def save_hl7_file(filename)
          create_hl7_file_at(Paths.outgoing.join(filename), :out)
          create_hl7_file_at(Paths.outgoing_archive.join(filename), :arc)
        end

        def create_hl7_file_at(filepath, type)
          File.write(filepath, message.body)
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
          transmission_log.update(
            transmitted_at: Time.zone.now,
            filepath: filepath,
            payload: message.body
          )
        end

        def log_error(err)
          logger.info("err hl7 #{patient.secure_id} #{patient.local_patient_id} #{err&.message}")
          transmission_log.update(error: err.message)
        end
      end
    end
  end
end
