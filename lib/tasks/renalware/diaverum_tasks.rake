# frozen_string_literal: true

require "benchmark"

namespace :diaverum do
  # Note this fitst task no longer required becuase we only send HL7 now, in real time.
  # desc "For the requested hospital unit_code, export per-patient Daverum XML files "\
  #      "for importing into iRIMS \n"\
  #      "Example usage \n"\
  #      "  bundle exec rake diaverum:export unit_code=THM \n"\
  #      "  bundle exec rake diaverum:export unit_code=THM destination_path='tmp'"
  # task export: :environment do
  #   Renalware::Diaverum::GeneratePatientXmlFiles.call(
  #     destination_path: ENV.fetch("unit_code", Rails.application.secrets.diaverum_export_path),
  #     hospital_unit_code: ENV["unit_code"] # passed in when invoking rake task - see desc
  #   )
  # end

  desc "Iterate through diaverum files in the folder $DIAVERUM_FOLDER that match the pattern "\
        "and for each file (it should be one per patient) import any sessions contained therein."
  task ingest: :environment do
    uuid = Renalware::Diaverum::Incoming::IngestXmlFiles.new.call
    Renalware::Diaverum::Incoming::GenerateSummaryFile.new(
      log_uuid: uuid,
      path: Renalware::Diaverum::Paths.outgoing
    ).call
  end
end
