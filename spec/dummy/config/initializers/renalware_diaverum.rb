# frozen_string_literal: true

# Here is where we configure the settings for the Renalware::Core engine.

require_dependency "renalware/diaverum"

Renalware::Diaverum.configure do |config|
  config.diaverum_outgoing_path = Rails.root.join("tmp", "diaverum", "out")
  config.diaverum_outgoing_archive_path = Rails.root.join("tmp", "diaverum", "out_archive")
  config.diaverum_incoming_path = Rails.root.join("tmp", "diaverum", "in")
  config.diaverum_incoming_archive_path = Rails.root.join("tmp", "diaverum", "in_archive")
  config.diaverum_incoming_error_path = Rails.root.join("tmp", "diaverum", "in_error")

  FileUtils.mkdir_p config.diaverum_outgoing_path
  FileUtils.mkdir_p config.diaverum_outgoing_archive_path
  FileUtils.mkdir_p config.diaverum_incoming_path
  FileUtils.mkdir_p config.diaverum_incoming_archive_path
  FileUtils.mkdir_p config.diaverum_incoming_error_path
end
