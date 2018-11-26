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

        # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        def call
          error_count = 0
          lines = []

          logs.each do |log|
            error_count += log.error_messages&.length
            errors = log.error_messages&.join(", ")
            warnings = log.warnings&.join(", ")
            lines << if log.parent_id.nil?
                       "File|#{log.filepath}|#{errors}|#{warnings}"
                     else
                       "Treatment|#{log.external_session_id}|#{errors}|#{warnings}"
                     end
          end
          filepath = Pathname(path).join(filename(error_count))
          logger.info("Writing summary file #{filepath}")
          File.open(filepath, "w") { |f| f.write(lines.join("\n")) }

          # return filepath Pathname
          filepath
        end
        # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
        #

        private

        # rubocop:disable Metrics/MethodLength
        # Log is a view over HD::TransmissionLog, grouping parent and child logs together
        def logs
          @logs ||= begin
            Renalware::HD::GroupedTransmissionLog
              .incoming
              .for_uuid(log_uuid)
              .select(
                :id,
                :parent_id,
                :filepath,
                :error_messages,
                :warnings,
                :external_session_id
              )
          end
        end
        # rubocop:enable Metrics/MethodLength

        def filename(error_count)
          result = error_count.to_i > 0 ? "err" : "ok"
          Time.zone.now.strftime("%Y%m%d_%H%M%S_#{result}.txt")
        end
      end
    end
  end
end
