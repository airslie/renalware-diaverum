# frozen_string_literal: true

require "active_support/concern"

module Renalware
  module Diaverum::Logging
    extend ActiveSupport::Concern

    def logger
      @logger ||= begin
        if Rails.env.development?
          Logger.new(STDOUT)
        else
          # syslog_logger = ActiveSupport::TaggedLogging.new(
          #   RemoteSyslogLogger.new(
          #     'logs6.papertrailapp.com', 41364,
          #     program: "rails-#{Rails.env}"
          #   )
          # )
          # Rails.logger.extend(ActiveSupport::Logger.broadcast(syslog_loger))
          # logr = Logger.new(STDOUT)
          # file_logger = ActiveSupport::TaggedLogging.new(
          #   Logger.new(
          #     Rails.root.join("log", "diaverum.log")
          #   )
          # )
          # logr.extend(ActiveSupport::Logger.broadcast(file_logger))
          #   #   #   RemoteSyslogLogger.new(
          #   #   #     'logs6.papertrailapp.com', 41364,
          #   #   #     program: "rails-#{Rails.env}"
          #   #   #   )
          #   #   # )
          #   # Logger.new(Rails.root.join("log", "diaverum.log")).tap do |logr|
          #   #   logr.extend(ActiveSupport::Logger.broadcast(STDOUT))
          #   # end
          # #end
          # logr
          Logger.new(STDOUT)
        end
      end
    end

    def logger=(logger)
      @logger = logger
    end
  end
end
