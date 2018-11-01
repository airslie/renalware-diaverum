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

        # rubocop:disable Metrics/MethodLength
        def import_xml_files(uuid)
          XmlFileList.new(logger, pattern).each_file do |filepath, filename|
            begin
              log_msg = "#{filename}..."
              transmission_log = create_transmission_log(filepath: filepath, uuid: uuid)
              SavePatientSessions.call(filepath, transmission_log)
              log_msg += "DONE"
            rescue StandardError => ex
              handle_ingest_error(filepath, ex, transmission_log)
              log_msg += "FAIL"
              next
            ensure
              FileUtils.mv filepath, Paths.incoming_archive.join(filename)
              logger.info log_msg
            end
          end
        rescue StandardError => exception
          raise exception
        end
        # rubocop:enable Metrics/MethodLength

        def create_transmission_log(filepath:, uuid:)
          HD::TransmissionLog.create!(
            direction: :in,
            format: :xml,
            filepath: filepath,
            uuid: uuid
          )
        end

        def pattern
          Paths.incoming.join("*.xml")
        end

        def handle_ingest_error(_filepath, exception, transmission_log)
          transmission_log.update!(error_messages: ["#{exception.cause} #{exception.message}"])
        end
      end
    end
  end
end
