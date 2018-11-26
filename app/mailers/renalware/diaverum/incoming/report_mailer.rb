# frozen_string_literal: true

module Renalware
  module Diaverum
    module Incoming
      class ReportMailer < ApplicationMailer
        # Send the report summary output from the diavereum:ingest rake task to interested
        # parties
        def import_summary(to:, summary_file_path:)
          to ||= config.diaverum_reporting_email_addresses
          filename = File.basename(summary_file_path)
          attachments[filename] = File.read(summary_file_path)
          mail(to: Array(to), subject: subject)
        end

        private

        def subject
          "Renalware Diaverum summary #{I18n.l(Time.zone.today)}"
        end
      end
    end
  end
end
