namespace :diaverum do
  desc "for the requeested hpspital unit id, export per-patient Daverum XML files "\
       "for importing into iRIMS \n"
       "Example usage bundle exec rake diaverum:export unit_code=THM"
  task export: :environment do
    Renalware::Diaverum::GeneratePatientXmlFiles.call(
      destination_path: Rails.application.secrets.diaverum_export_path,
      hospital_unit_code: ENV.fetch("unit_code") # will raise an error if not supplied
    )
  end
end
