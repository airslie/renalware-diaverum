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
          GenerateSummaryFile.new(log_uuid: uuid, path: Paths.outgoing_archive).call
        rescue StandardError => exception
          Renalware::Engine.exception_notifier.notify(exception)
          raise exception
        end
      end
    end
  end
end
