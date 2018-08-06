# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      class IngestXmlFiles
        include Diaverum::Logging

        def call
          uuid = SecureRandom.uuid
          import_xml_files(uuid)
          uuid
        end

        private

        def import_xml_files(uuid)
          filename = nil
          filepath = nil
          transmission_log = nil
          logger.info "Ingesting Diaverum HD Sessions using pattern #{pattern}"
          Dir.glob(pattern).sort.each do |filepath|
            filename = File.basename(filepath)

            log_msg = "#{filename}..."
            begin
              transmission_log = HD::TransmissionLog.create!(
                direction: :in,
                format: :xml,
                filepath: filepath,
                uuid: uuid
              )
              Diaverum::Incoming::SavePatientSessions.call(filepath, transmission_log)
              log_msg += "DONE"
            rescue StandardError => ex
              handle_ingest_error(filepath, ex, transmission_log)
              log_msg += "FAIL"
              raise ex

              # Engine.exception_notifier.notify(exception)
              next
            ensure
              FileUtils.mv filepath, Paths.incoming_archive.join(filename)
              logger.info log_msg
            end
          end
        rescue StandardError => exception
          handle_ingest_error(filepath, exception, transmission_log)
          raise exception
          # Engine.exception_notifier.notify(exception)
        end

        def pattern
          Paths.incoming.join("*.xml")
        end

        def handle_ingest_error(filepath, exception, transmission_log)
          transmission_log.update!(error_messages: ["#{exception.cause} #{exception.message}"])
        end
      end
    end
  end
end
