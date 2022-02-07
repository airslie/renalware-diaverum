# frozen_string_literal: true

require "benchmark"

namespace :diaverum do
  desc "Re-creates missing pathology .hl7 files for Diaverum patients for a given period "\
       "example usage "\
       "rake diaverum:recreate_pathology_files from_date=2019-10-30 to_date=2019-11-15"
  # You can also pass in a nhs_number
  task recreate_pathology_files: :environment do
    from_date = DateTime.parse(ENV.fetch("from_date")).beginning_of_day
    to_date = DateTime.parse(ENV.fetch("to_date")).end_of_day
    nhs_number = ENV["nhs_number"]

    diaverum_unit_ids = Renalware::HD::ProviderUnit
      .joins(:hd_provider)
      .where("hd_providers.name ilike 'Diaverum'")
      .pluck(:hospital_unit_id)

    nhs_numbers = Array(nhs_numbers).compact
    if nhs_numbers.empty?
      nhs_numbers = Renalware::HD::Patient
        .joins(hd_profile: :hospital_unit)
        .where(hd_profiles: { hospital_unit_id: diaverum_unit_ids })
        .pluck(:nhs_number)
    end

    messages = Renalware::Feeds::Message
      .where(patient_identifier: nhs_numbers)
      .where("created_at >= ? and created_at < ?", from_date, to_date)
      .where("event_code like 'ORU%'")

    puts "Using diaverum unit ids: #{diaverum_unit_ids.join(', ')}"
    puts "Applying to patients with nhs_numbers: #{nhs_numbers.join(', ')}"
    puts "Between #{from_date} and #{to_date}"

    if messages.length.zero?
      puts "No matching feed_messags found!"
    else
      puts "Sending #{messages.length} messages "
      puts "(files will be created in the background in #{Renalware::Diaverum::Paths.outgoing})"
      puts
      messages.each do |message|
        puts "#{I18n.l(message.created_at)} #{message.event_code} #{message.patient_identifier}"
        Renalware::Diaverum::Outgoing::PathologyListener.oru_message_processed(
          feed_message: message
        )
      end
    end
  end
end
