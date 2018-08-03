# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      # Once an import has finished we dump the results from the hd_transmission_log
      # into a file so Diaverum can inspect what happened.
      class GenerateSummaryFile
        include Diaverum::Logging
        pattr_initialize [:path!, :log_uuid!]

        def call
          filepath = Pathname(path).join(filename)
          logger.info("Writing summary file #{filepath}")
          File.open(filepath, "w") do |f|
            matching_logs.each do |log|
              f << log.external_session_id
              f << "|"
              f << log.error_messages.join(", ")
              f << "\n"
            end
          end
        end

        private

        def filename
          result = validation_errors? ? "err" : "ok"
          Time.zone.now.strftime("%Y%m%d_%H%M%S_#{result}.txt")
        end

        def matching_logs
          @matching_logs ||= begin
            parent_logs = Renalware::HD::TransmissionLog.where(uuid: log_uuid)
            Renalware::HD::TransmissionLog.where(parent_id: parent_logs.map(&:id))
          end
        end

        def validation_errors?
          matching_logs.count{ |log| !log.error_messages.empty? } > 0
        end
      end
    end
  end
end
