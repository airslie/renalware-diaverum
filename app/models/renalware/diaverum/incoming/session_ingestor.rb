# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      class SessionIngestor
        pattr_initialize [:paths!, :logger!]

        def call
          filename = nil
          filepath = nil
          puts "Ingesting Diaverum HD Sessions"
          Dir.glob(pattern).sort.each do |fp|
            filepath = fp
            filename = File.basename(filepath)
            log_msg = "#{filename}..."
            begin
              Diaverum::SavePatientSessions.call(filepath)
              FileUtils.mv filepath, paths.archive.join(filename)
              log_msg += "OK"
            rescue StandardError => ex
              handle_ingest_error(filepath, ex)
              log_msg += "FAIL"

              # Engine.exception_notifier.notify(exception)
              next
            ensure
              puts log_msg
            end
          end
        rescue StandardError => exception
          handle_ingest_error(filepath, exception)
          raise exception
          # Engine.exception_notifier.notify(exception)
        end

        private

        def pattern
          paths.home.join("*.xml")
        end

        def handle_ingest_error(filepath, exception)
          move_failed_xml_to_error_folder(filepath)
          create_error_file_in_error_folder(filepath, exception)
        end

        def move_failed_xml_to_error_folder(filepath)
          FileUtils.mv filepath, paths.error.join(File.basename(filepath))
        end

        def create_error_file_in_error_folder(filepath, exception)
          filename = File.basename(filepath)
          msg = "#{exception.class}: #{exception.message}:\n\t#{exception.backtrace.join("\n\t")}"
          File.write(paths.error.join("#{filename}.log"), msg)
        end
      end
    end
  end
end
