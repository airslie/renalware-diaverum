# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      # A top-level class called by the rake rask, wrapping the neccessary calls
      # and error reporting
      class Ingestor
        def call
          uuid = ImportHDSessionsFromXmlFiles.new.call
          GenerateSummaryFile.new(log_uuid: uuid, path: Paths.outgoing).call
          file_path = GenerateSummaryFile.new(log_uuid: uuid, path: Paths.outgoing_archive).call
          email_summary_report(file_path)
        rescue StandardError => exception
          Renalware::Engine.exception_notifier.notify(exception)
          raise exception
        end

        private

        def email_summary_report(summary_file_path)
          ReportMailer.import_summary(
            summary_file_path: summary_file_path.to_s,
            to: Diaverum.config.diaverum_reporting_email_addresses
          ).deliver_later
        end
      end
    end
  end
end
