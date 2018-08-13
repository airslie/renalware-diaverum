# frozen_string_literal: true

require "rails_helper"
require "tmpdir"

module Renalware
  module Diaverum
    RSpec.describe Incoming::GenerateSummaryFile do
      describe ".call" do
        context "when there are no validation errors" do
          it "outputs a _ok.txt file with a list of treatment ids" do
            log_uuid = SecureRandom.uuid
            parent = create(
              :hd_transmission_log,
              :incoming_xml,
              uuid: log_uuid,
              filepath: "somefile"
            )
            create(
              :hd_transmission_log,
              :incoming_xml,
              parent: parent,
              external_session_id: "S1"
            )
            date = Time.zone.parse("2017-11-24 01:04:44")
            travel_to(date) do
              Dir.mktmpdir do |dir|
                Dir.chdir dir do
                  described_class.new(path: "", log_uuid: log_uuid).call

                  expected_filename = "20171124_010444_ok.txt"
                  expect(File.exist?(expected_filename)).to eq(true)
                  expect(File.open(expected_filename).read).to eq("File|somefile|\nTreatment|S1|")
                end
              end
            end
          end
        end
        context "when there are validation errors" do
          it "outputs a _err.txt file with the errors in it" do
            log_uuid = SecureRandom.uuid
            parent = create(
              :hd_transmission_log,
              :incoming_xml,
              uuid: log_uuid,
              filepath: "somefile"
            )
            create(
              :hd_transmission_log,
              :incoming_xml,
              parent: parent,
              external_session_id: "S1",
              error_messages: %w(A B C)
            )
            date = Time.zone.parse("2017-11-24 01:04:44")
            travel_to(date) do
              Dir.mktmpdir do |dir|
                Dir.chdir dir do
                  described_class.new(path: "", log_uuid: log_uuid).call

                  expected_filename = "20171124_010444_err.txt"
                  expect(File.exist?(expected_filename)).to eq(true)
                  expect(File.open(expected_filename).read)
                    .to eq("File|somefile|\nTreatment|S1|A, B, C")
                end
              end
            end
          end
        end
      end
    end
  end
end
