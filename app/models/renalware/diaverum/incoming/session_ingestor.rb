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
          transmission = nil
          logger.info "Ingesting Diaverum HD Sessions"
          Dir.glob(pattern).sort.each do |filepath|
            filename = File.basename(filepath)

            log_msg = "#{filename}..."
            begin
              transmission = Transmission.create!(
                direction: :in,
                format: :xml,
                filepath: filepath
              )
              Diaverum::Incoming::SavePatientSessions.call(filepath, transmission)
              FileUtils.mv filepath, Paths.archive.join(filename)
              log_msg += "OK"
            rescue StandardError => ex
              handle_ingest_error(filepath, ex, transmission)
              log_msg += "FAIL"
              raise ex

              # Engine.exception_notifier.notify(exception)
              next
            ensure
              puts log_msg
            end
          end
        rescue StandardError => exception
          handle_ingest_error(filepath, exception, transmission)
          raise exception
          # Engine.exception_notifier.notify(exception)
        end

        private

        def pattern
          Paths.incoming.join("*.xml")
        end

        def handle_ingest_error(filepath, exception, transmission)
          if filepath.present?
            move_failed_xml_to_error_folder(filepath)
            create_error_file_in_error_folder(filepath, exception)
          end
          transmission.update!(error: "#{exception.cause} #{exception.message}")
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
