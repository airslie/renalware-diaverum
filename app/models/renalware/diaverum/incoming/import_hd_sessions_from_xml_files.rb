# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      class ImportHDSessionsFromXmlFiles
        include Diaverum::Logging

        def call
          SecureRandom.uuid.tap do |uuid|
            import_xml_files(uuid)
          end
        end

        private

        # rubocop:disable Metrics/MethodLength
        def import_xml_files(uuid)
          XmlFileList.new(logger, pattern).each_file do |filepath, filename|
            begin
              log_msg = "#{filename}..."
              transmission_log = create_transmission_log(filepath: filepath, uuid: uuid)
              SaveSessions.call(path_to_xml: filepath, log: transmission_log)
              log_msg += "DONE"
            rescue StandardError => ex
              handle_ingest_error(filepath, ex, transmission_log)
              log_msg += "FAIL"
              # raise(ex) if Rails.env.development?
              next
            ensure
              archive_incoming_file(filename, filepath)
              logger.info log_msg
            end
          end
        rescue StandardError => exception
          raise exception
        end
        # rubocop:enable Metrics/MethodLength

        # We have experiened persmission denied/invalid cross-device link
        # errors attempting to move files from a network share to the local
        # archive/incoming folder. Provide an alternative implementation
        # which does a cp then an rm in attempt to skip the implicit rename
        # that occurs during a mv.
        def archive_incoming_file(filename, filepath)
          if ENV.key?("DIAVERUM_DO_NOT_USE_MV")
            FileUtils.cp filepath, Paths.incoming_archive.join(filename)
            FileUtils.rm filepath
          else
            FileUtils.mv filepath, Paths.incoming_archive.join(filename)
          end
        end

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
