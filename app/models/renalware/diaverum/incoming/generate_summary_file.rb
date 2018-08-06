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
          error_count = 0
          lines = []
          file_logs.each do |file_log|
            lines << "File|#{file_log.filepath}|#{file_log.error_messages&.join(', ')}"
            error_count += file_log.error_messages&.length
            file_log.children.each do |log|
              lines << "Treatment|#{log.external_session_id}|#{log.error_messages&.join(', ')}"
              error_count += log.error_messages&.length
            end
          end
          filepath = Pathname(path).join(filename(error_count))
          logger.info("Writing summary file #{filepath}")
          File.open(filepath, "w") { |f| f.write(lines.join("\n")) }
        end

        private

        def filename(error_count)
          result = error_count.to_i > 0 ? "err" : "ok"
          Time.zone.now.strftime("%Y%m%d_%H%M%S_#{result}.txt")
        end

        def file_logs
          @file_logs ||= Renalware::HD::TransmissionLog.where(uuid: log_uuid)
        end
      end
    end
  end
end
