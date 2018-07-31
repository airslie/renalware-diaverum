# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      class SessionIngestor
        include Diaverum::Logging

        def self.call
          new.call
        end

        def call
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
                filepath: filepath
              )
              Diaverum::Incoming::SavePatientSessions.call(filepath, transmission_log)
              FileUtils.mv filepath, Paths.incoming_archive.join(filename)
              log_msg += "DONE"
            rescue StandardError => ex
              handle_ingest_error(filepath, ex, transmission_log)
              log_msg += "FAIL"
              # raise ex

              # Engine.exception_notifier.notify(exception)
              next
            ensure
              logger.info log_msg
            end
          end
        rescue StandardError => exception
          handle_ingest_error(filepath, exception, transmission_log)
          raise exception
          # Engine.exception_notifier.notify(exception)
        end

        private

        def pattern
          Paths.incoming.join("*.xml")
        end

        def handle_ingest_error(filepath, exception, transmission_log)
          if filepath.present?
            move_failed_xml_to_error_folder(filepath)
            create_error_file_in_error_folder(filepath, exception)
          end
          transmission_log.update!(error_messages: ["#{exception.cause} #{exception.message}"])
        end

        def move_failed_xml_to_error_folder(filepath)
          FileUtils.mv filepath, Paths.incoming_error.join(File.basename(filepath))
        end

        def create_error_file_in_error_folder(filepath, exception)
          filename = File.basename(filepath)
          msg = "#{exception.class}: #{exception.message}:\n\t#{exception.backtrace.join("\n\t")}"
          File.write(Paths.incoming_error.join("#{filename}.log"), msg)
        end
      end
    end
  end
end
