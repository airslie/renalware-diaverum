# frozen_string_literal: true

require "rails_helper"

# TODO: Improvements
# - log individual entries to results {}
# - test SaveSession in isolation
# - break up #call
module Renalware
  module Diaverum
    module Incoming
      RSpec.describe SavePatientSessions do
        include DiaverumHelpers
        let!(:system_user) { create(:user, username: SystemUser.username) }
        let(:patient) { create(:hd_patient, local_patient_id: "KCH123", nhs_number: "0123456789") }
        let(:transmission_log) do
          HD::TransmissionLog.create!(
            direction: :in,
            format: :xml
          )
        end
        before { Diaverum.config.diaverum_incoming_skip_session_save = false }

        around(:each) do |example|
          using_a_tmp_diaverum_path{ example.run }
        end

        context "when Diaverum @ St Albans has SFTPed multiple patient XML files, each containing "\
                "up to 30 calendar days of HD Session (aka Treament) history, and a rake task "\
                "has iterated over the files and passed us a single file to import" do

          context "when we can identify the patient, and the all the sessions in the file are "\
                  "new ones e.g. because this is a new patient, or the rake task is running for "\
                  "the first time and needs to catchup on the (up to 30 days of) backlog" do

            let(:xml_filepath) { file_fixture("diaverum_example.xml.erb") }
            let(:doc) do
              # Set up an erb template based on the XML fixture so we can insert patient identifiers
              # into the XML.By magic, the patient variable is in binding so can be resolved in
              # the ERB template
              xml = ERB.new(xml_filepath.read).result(binding)
              Nokogiri::XML(xml)
            end
            let(:payload) { PatientXmlDocument.new(doc) }

            context "when all sessions are valid" do
              it "delegates session creation to SessionBuilder" do
                allow(SessionBuilder)
                  .to receive(:call)
                  .and_return(build(:hd_closed_session, patient: patient, by: system_user))

                SavePatientSessions.new(payload, transmission_log).call

                expect(SessionBuilder).to have_received(:call).twice
              end

              context "when config.diaverum_incoming_skip_session_save is true" do
                it "does not attempt to save the session but still logs (without session id)" do
                  Diaverum.config.diaverum_incoming_skip_session_save = true
                  allow(SessionBuilder)
                    .to receive(:call)
                    .and_return(build(:hd_closed_session, patient: patient, by: system_user))

                  expect{
                    SavePatientSessions.new(payload, transmission_log).call
                  }.to change(HD::Session, :count).by(0)
                  .and change(HD::TransmissionLog, :count).by(3)

                  expect(HD::TransmissionLog.pluck(:session_id).uniq.compact.count).to eq(0)
                  Diaverum.config.diaverum_incoming_skip_session_save = false
                end
              end
            end

            context "when sessions are invalid because they are missing an end_time" do
              let(:end_time) { nil }

              it "does not create any new sessions" do
                allow(SessionBuilder)
                  .to receive(:call)
                  .and_return(
                    build(
                      :hd_closed_session,
                      patient: patient,
                      by: system_user,
                      end_time: nil
                    )
                  )

                expect{
                  SavePatientSessions.new(payload, transmission_log).call
                }.to change(HD::Session, :count).by(0)
              end

              it "logs an error to each child TransmissionLog" do
                allow(SessionBuilder)
                  .to receive(:call)
                  .and_return(
                    build(
                      :hd_closed_session,
                      patient: patient,
                      by: system_user,
                      end_time: nil
                    )
                  )

                expect{
                  SavePatientSessions.new(payload, transmission_log).call
                }.to change(HD::TransmissionLog, :count).by(3) # 1 parent 2 children

                parent_logs = HD::TransmissionLog.where(parent_id: nil).all
                expect(parent_logs.length).to eq(1)
                parent_log = parent_logs.first
                expect(parent_log.error_messages).to eq([])

                child_logs = parent_log.children
                expect(child_logs.length).to eq(2)
                expect(child_logs.map(&:error_messages).flatten.uniq)
                  .to eq(["Session End Time can't be blank"])
              end

              context "when config.diaverum_incoming_skip_session_save is true" do
                it "does not attempt to save the session but still logs with errors" do
                  Diaverum.config.diaverum_incoming_skip_session_save = true

                  allow(SessionBuilder)
                    .to receive(:call)
                    .and_return(
                      build(
                        :hd_closed_session,
                        patient: patient,
                        by: system_user,
                        end_time: nil
                      )
                    )

                  expect {
                    SavePatientSessions.new(payload, transmission_log).call
                  }.to change(HD::Session, :count).by(0)

                  parent_logs = HD::TransmissionLog.where(parent_id: nil).all
                  expect(parent_logs.length).to eq(1)
                  parent_log = parent_logs.first
                  expect(parent_log.error_messages).to eq([])

                  child_logs = parent_log.children
                  expect(child_logs.length).to eq(2)
                  expect(child_logs.map(&:error_messages).flatten.uniq)
                    .to eq(["Session End Time can't be blank"])
                end
              end
            end

            describe "handling of duplicates" do
              context "when the same session is imported again (which will happen everyday) as "\
                      "the file contains the last 30 days of sesssons" do
                let(:access_type) { create(:access_type) }
                let(:user) { create(:user) }
                let(:provider) { HD::Provider.create!(name: "Diaverum") }
                let(:dialysis_unit) do
                  HD::ProviderUnit.create!(
                    hospital_unit: hospital_unit,
                    hd_provider: provider,
                    providers_reference: "123"
                  )
                end
                let(:dialysate) { create(:hd_dialysate) }
                let(:hospital_unit) { create(:hospital_unit) }

                it "does not change the previously saved session" do
                  # The first session has a TreatmentID of 1 in the file, the second is 2
                  Diaverum.config.diaverum_incoming_skip_session_save = false
                  create_access_map
                  create_hd_type_map
                  create_dry_weight
                  create(:hd_closed_session, patient: patient, by: system_user, external_id: "1")

                  # Should only import 1 new one
                  expect{
                    SavePatientSessions.new(payload, transmission_log).call
                  }.to change(HD::Session, :count).by(1)
                end
              end
            end
          end
        end
      end
    end
  end
end
