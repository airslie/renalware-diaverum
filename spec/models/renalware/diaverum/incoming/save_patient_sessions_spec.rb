# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      RSpec.describe SavePatientSessions do
        include DiaverumHelpers
        let!(:system_user) { create(:user, username: SystemUser.username) }
        let(:patient) { create(:hd_patient, local_patient_id: "KCH123", nhs_number: "0123456789") }
        let(:hospital_unit) { create(:hospital_unit) }
        let(:dialysate)     { create(:hd_dialysate) }
        let(:provider)      { HD::Provider.create!(name: "Diaverum") }
        let(:dialysis_unit) do
          HD::ProviderUnit.create!(
            hospital_unit: hospital_unit,
            hd_provider: provider,
            providers_reference: "123"
          )
        end
        let(:transmission_log) do
          HD::TransmissionLog.create!(
            direction: :in,
            format: :xml
          )
        end
        before { Diaverum.config.diaverum_incoming_skip_session_save = false }

        def create_access_map
          AccessMap.create!(
            diaverum_location_id: "LEJ",
            diaverum_type_id: 7,
            access_type: create(:access_type)
          )
        end

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
            let!(:access_map) do
              AccessMap.create!(
                diaverum_location_id: "LEJ",
                diaverum_type_id: 7,
                access_type: create(:access_type),
                side: :left
              )
            end

            it "meta test: fixture rendered via ERB contains patient data bound via "\
               "'patient' variable" do
              expect(payload.local_patient_id).to eq(patient.local_patient_id)
              expect(payload.nhs_number).to eq(patient.nhs_number)
            end

            context "when all sessions are valid" do
              it "creates a new HD session for each session in the file" do
                Diaverum.config.diaverum_incoming_skip_session_save = false
                expect{
                  SavePatientSessions.new(payload, transmission_log).call
                }.to change(HD::Session, :count).by(2)
                .and change(patient.hd_sessions.closed, :count).by(2)

                expect(HD::TransmissionLog.pluck(:session_id).uniq.compact.count).to eq(2)
              end

              context "when config.diaverum_incoming_skip_session_save is true" do
                it "does not attempt to save the session but still logs (without session id)" do
                  Diaverum.config.diaverum_incoming_skip_session_save = true
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
                expect{
                  SavePatientSessions.new(payload, transmission_log).call
                }.to change(HD::Session, :count).by(0)
              end

              it "logs an error to each child TransmissionLog" do
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
          end
        end
      end
    end
  end
end
