# frozen_string_literal: true

require "benchmark"

namespace :diaverum do
  desc "Iterate through diaverum files in the folder $DIAVERUM_FOLDER that match the pattern "\
        "and for each file (it should be one per patient) import any sessions contained therein."
  task ingest: :environment do
    Renalware::Diaverum::Incoming::Ingestor.new.call
  end

  task housekeeping: :environment do
    logger           = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    logger.level     = Logger::INFO
    Rails.logger     = logger
    logger.info "Diaverum housekeeping"
    Renalware::Diaverum::Housekeeping::RemoveOldArchives.new.call
  end
end
