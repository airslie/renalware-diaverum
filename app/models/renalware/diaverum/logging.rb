# frozen_string_literal: true

require "active_support/concern"

module Renalware
  module Diaverum::Logging
    extend ActiveSupport::Concern

    def logger
      @logger ||= Rails.env.development? ? Logger.new(STDOUT) : logger_to_stdout_and_file
    end

    def logger=(logger)
      @logger = logger
    end

    def logger_to_stdout_and_file
      Logger.new(STDOUT).tap do |std_out_logger|
        file_logger = ActiveSupport::TaggedLogging.new(
          Logger.new(Rails.root.join("log", "diaverum.log"))
        )
        std_out_logger.extend(ActiveSupport::Logger.broadcast(file_logger))
      end
    end
  end
end
