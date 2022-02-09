# frozen_string_literal: true

require "benchmark"

namespace :diaverum do
  desc "Re-creates missing pathology .hl7 files for Diaverum patients for a given period "\
       "example usage "\
       "rake diaverum:recreate_pathology_files from_date=2019-10-30 to_date=2019-11-15"
  task recreate_pathology_files: :environment do
    messages = Renalware::Diaverum::Outgoing::FeedMessagesQuery.call(
      from_date: ENV.fetch("from_date"),
      to_date: ENV.fetch("to_date")
    )

    # puts "Using diaverum unit ids: #{diaverum_unit_ids.join(', ')}"
    # puts "Applying to patients with nhs_numbers: #{nhs_numbers.join(', ')}"
    # puts "Between #{from_date} and #{to_date}"

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
