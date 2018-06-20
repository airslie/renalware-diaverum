require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      RSpec.describe SavePatientSessions do
        let(:system_user) { create(:user, username: Renalware::SystemUser.username) }
        let(:patient) { create(:hd_patient, local_patient_id: "KCH123", nhs_number: "0123456789") }
        let(:hospital_unit) { create(:hospital_unit) }
        let(:dialysate) { create(:hd_dialysate) }

        def create_xml_file_from_fixture(fixture_name)
          fixture = file_fixture("diaverum_#{fixture_name}.xml.erb")
          xml_content = ERB.new(xml_filepath.read).result(binding)
          xml_filepath = File.join(ENV["DIAVERUM_FOLDER"], "#{fixture_name}.xml")
          File.write(xml_filepath, xml_content)
        end

        before do
          # Wire up the Diaverum path somewhere safe
          path = Rails.root.join("tmp", "diaverum")
          FileUtils.mkdir_p(path)
          ENV["DIAVERUM_FOLDER"] = path.to_s
        end

        context "when Diaverum @ St Albans has SFTPed multiple patient XML files, each containing up to "\
                "30 calendar days of HD Session (aka Treament) history, "\
                "and a rake task has iterated over the files and passed us a single file to import" do

          context "when we can identifiy the patient, and the all the sessions in the file are new ones "\
                  "e.g. because this is a new patient, or the rake task is running for the first time "\
                  "and needs to catchup on the (up to 30 days of) backlog" do

            let(:xml_filepath) { file_fixture("diaverum_example.xml.erb") }
            let(:doc) do
              # Set up an erb template based on the XML fixture so we can insert patient identifiers
              # into the XML.By magic, the patient variable is in binding so can be resolved in the ERB
              # template
              xml = ERB.new(xml_filepath.read).result(binding)
              Nokogiri::XML(xml)
            end

            it "meta test: fixture rendered via ERB contains patient data bound via 'patient' variable" do
              payload = PatientXmlDocument.new(doc)

              expect(payload.local_patient_id).to eq(patient.local_patient_id)
              expect(payload.nhs_number).to eq(patient.nhs_number)
            end

            it "creates a new HD session for each session in the file" do
              system_user
              p dialysate.id
              payload = PatientXmlDocument.new(doc)
              create_xml_file_from_fixture(:example)

              expect{
                SavePatientSessions.new(payload).call
              }.to change(patient.hd_sessions.open, :count).by(2)
            end
          end
        end
      end
    end
  end
end
