# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      # class Summary
      #   attr_reader :lines, :errors

      #   def initalize
      #     @lines = []
      #     @errors = []
      #   end

      #   def to_s; end
      # end

      # class GenerateSummary
      #   def call
      #     summary = Summary.new
      #     file_logs.each do |file_log|
      #       summary.lines << "File|#{file_log.filepath}|#{file_log.error_messages&.join(', ')}"
      #       summary.errors << file_log.error_messages if file_log.error_messages.any?

      #       file_log.children.each do |log|
      #         line = "Treatment|#{log.external_session_id}|#{log.error_messages&.join(', ')}"
      #         summary.lines << line
      #         summary.errors << log.error_messages if log.error_messages.any?
      #       end
      #     end
      #     summary
      #   end
      # end
    end
  end
end
