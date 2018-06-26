# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    RSpec.describe Outgoing::CreateHl7FileFromFeedMessage do
      let(:patient) do
        create(:hd_patient, born_on: "01-12-2000", nhs_number: "0123456789", local_patient_id: "kch1")
      end
      let(:user) { create(:user) }
      let(:logger) { Logger.new(STDOUT) }
      let(:some_other_unit) { create(:hospital_unit, unit_code: "NOTDIAVERUM") }
      let(:diaverum_unit) { create(:hospital_unit, unit_code: "DIAVERUM") }
      let(:time) { "2018-01-01 01:01:01" }

      describe ".call" do
        subject(:result) { described_class.new(message: message, logger: logger).call }
        context "when there is no patient_identifier on the message" do
          let(:message) { Feeds::Message.new }

          it "logs a warning but does nothing" do
            allow(logger).to receive(:warn)

            expect(result).to be_nil

            expect(logger).to have_received(:warn)
          end
        end

        context "when there is a patient_identifier on the message" do
          context "when the patient is not found" do
            let(:message) { Feeds::Message.new(patient_identifier: "NNN") }

            it "logs a warning but does nothing" do
              allow(logger).to receive(:warn)

              expect(result).to be_nil

              expect(logger).to have_received(:warn)
            end
          end

          context "when patient is found" do
            let(:message) do
              Feeds::Message.new(
                patient_identifier: patient.local_patient_id,
                body: "HL7 content"
              )
            end

            context "when they have no hd profile" do
              it "does nothing" do
                expect(result).to be_nil
              end
            end

            context "when they have an HD profile" do
              context "when the profile has no hospital_unit" do
                it "does nothing" do
                  create(:hd_profile, patient: patient, hospital_unit: nil)

                  expect(result).to be_nil
                end
              end

              context "when they dialyse elsewhere" do
                it "does nothing" do
                  create(:hd_profile, patient: patient, hospital_unit: some_other_unit)

                  expect(result).to be_nil
                end
              end

              context "when they dialyse at a Diaverum unit" do
                before do
                  create(:hd_profile, patient: patient, hospital_unit: diaverum_unit)
                  Diaverum::DialysisUnit.create!(hospital_unit: diaverum_unit)
                  Renalware::Diaverum.configure do |config|
                    diaverum_path = Rails.root.join("tmp", "diaverum")
                    config.diaverum_outgoing_path = diaverum_path.join("in").to_s
                    config.diaverum_outgoing_archive_path = diaverum_path.join("in_archive").to_s
                    FileUtils.mkdir_p config.diaverum_outgoing_path
                    FileUtils.mkdir_p config.diaverum_outgoing_archive_path
                  end
                end

                it "creates HL7 files in the diaverum 'out' and 'out archive' folders" do
                  travel_to(time) do
                    allow(File).to receive(:write)

                    expect(result).not_to be_nil

                    expect(File).to have_received(:write).twice

                    expect(File)
                      .to have_received(:write)
                      .with(expected_filepath_for(patient, message), "HL7 content")

                    expect(File)
                      .to have_received(:write)
                      .with(expected_archive_filepath_for(patient, message), "HL7 content")
                  end
                end

                it "logs the activity" do
                  travel_to(time) do
                    allow(logger).to receive(:info)

                    expect(result).not_to be_nil

                    expect(logger).to have_received(:info)
                  end
                end

                def expected_filepath_for(patient, message)
                  expected_filename = hl7_filename_for(patient, message)
                  Pathname(Diaverum.config.diaverum_outgoing_archive_path).join(expected_filename)
                end

                def expected_archive_filepath_for(patient, message)
                  expected_filename = hl7_filename_for(patient, message)
                  Pathname(Diaverum.config.diaverum_outgoing_path).join(expected_filename)
                end

                def hl7_filename_for(patient, message)
                  Outgoing::Hl7Filename.new(patient: patient, message: message).to_s
                end
              end
            end
          end
        end
      end
    end
  end
end
