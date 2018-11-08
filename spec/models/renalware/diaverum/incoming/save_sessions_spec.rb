# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      RSpec.describe SaveSessions do
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

            let(:xml_filepath) {
              file = file_fixture("diaverum_example.xml.erb")
              xml = ERB.new(file.read).result(binding)
              tempfile = Tempfile.new("diaverum_example")
              tempfile.write(xml)
              tempfile.close
              tempfile.path
            }

            context "when all sessions are valid" do
              it "delegates session creation to SessionBuilders::Closed" do
                closed_session = build(
                  :hd_closed_session,
                  patient: patient,
                  by: system_user
                )
                builder = instance_double(SessionBuilders::Closed, call: closed_session)
                allow(SessionBuilders::Factory).to receive(:builder_for).and_return(builder)

                SaveSessions.new(path_to_xml: xml_filepath, log: transmission_log).call

                expect(builder).to have_received(:call).twice
              end

              context "when config.diaverum_incoming_skip_session_save is true" do
                it "does not attempt to save the session but still logs (without session id)" do
                  Diaverum.config.diaverum_incoming_skip_session_save = true

                  closed_session = build(
                    :hd_closed_session,
                    patient: patient,
                    by: system_user
                  )
                  builder = instance_double(SessionBuilders::Closed, call: closed_session)
                  allow(SessionBuilders::Factory).to receive(:builder_for).and_return(builder)

                  expect{
                    SaveSessions.new(path_to_xml: xml_filepath, log: transmission_log).call
                  }.to change(HD::Session, :count).by(0)
                  .and change(HD::TransmissionLog, :count).by(3)

                  expect(HD::TransmissionLog.pluck(:session_id).uniq.compact.count).to eq(0)
                  expect(HD::TransmissionLog.pluck(:error_messages).flatten.compact.uniq).to eq([])

                  Diaverum.config.diaverum_incoming_skip_session_save = false
                end
              end
            end

            context "when sessions are invalid because they are missing an end_time" do
              let(:end_time) { nil }

              before do
                closed_session = build(
                  :hd_closed_session,
                  patient: patient,
                  by: system_user,
                  end_time: nil
                )
                builder = instance_double(SessionBuilders::Closed, call: closed_session)
                allow(SessionBuilders::Factory).to receive(:builder_for).and_return(builder)
              end

              it "does not create any new sessions" do
                expect{
                  SaveSessions.new(path_to_xml: xml_filepath, log: transmission_log).call
                }.to change(HD::Session, :count).by(0)
              end

              it "logs an error to each child TransmissionLog" do
                expect{
                  SaveSessions.new(path_to_xml: xml_filepath, log: transmission_log).call
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
                    SaveSessions.new(path_to_xml: xml_filepath, log: transmission_log).call
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
                    SaveSessions.new(path_to_xml: xml_filepath, log: transmission_log).call
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
