# frozen_string_literal: true

require "rails_helper"

# we want to test that
# a) values are mapped correctly
# b) validation works if value missing or out of range
module Renalware
  module Diaverum
    module Incoming
      RSpec.describe SessionBuilder do
        include DiaverumHelpers
        subject(:builder) do
          described_class.new(patient: patient, treatment_node: treatment_node)
        end
        let(:patient) { build(:hd_patient, local_patient_id: "KCH123", nhs_number: "0123456789") }
        let(:treatment_node) { nil }

        let(:xml_filepath) { file_fixture("diaverum_example.xml.erb") }
        let(:payload) { PatientXmlDocument.new(doc) }
        let(:doc) do
          # Set up an erb template based on the XML fixture so we can insert patient identifiers
          # into the XML.By magic, the patient variable is in binding so can be resolved in
          # the ERB template
          xml = ERB.new(xml_filepath.read).result(binding)
          Nokogiri::XML(xml)
        end
        let(:treatment_node) { payload.session_nodes.first }
        let(:hospital_unit) { build_stubbed(:hospital_unit) }
        let(:dialysis_unit) do
          build_stubbed(:hd_provider_unit, hospital_unit: hospital_unit, providers_reference: "123")
        end
        let(:dialysate)     { build_stubbed(:hd_dialysate) }
        let(:provider)      { HD::Provider.create!(name: "Diaverum") }

        it "asas" do
          builder.call
        end
      end
    end
  end
end

# we want to test that
# a) values are mapped correctly
# b) validation works if value missing or out of range
#
#       # let!(:system_user) { create(:user, username: SystemUser.username) }
#       let(:patient) { create(:hd_patient, local_patient_id: "KCH123", nhs_number: "0123456789") }
#       let(:transmission_log) do
#         HD::TransmissionLog.create!(
#           direction: :in,
#           format: :xml
#         )
#       end
#
#       before { Diaverum.config.diaverum_incoming_skip_session_save = false }
#       around(:each){ |example| using_a_tmp_diaverum_path{ example.run } }
#
#       let(:xml_filepath) { file_fixture("diaverum_example.xml.erb") }
#       let(:doc) do
#         # Set up an erb template based on the XML fixture so we can insert patient identifiers
#         # into the XML.By magic, the patient variable is in binding so can be resolved in
#         # the ERB template
#         xml = ERB.new(xml_filepath.read).result(binding)
#         Nokogiri::XML(xml)
#       end
#       let(:payload) { PatientXmlDocument.new(doc) }
#       it "meta test: there should be 2 sessions in the XML file" do
#         expect(payload.session_nodes.count).to eq(2)
#       end
#
#       context "when the HDType is HFLUX" do
#         let(:hd_type) { "HFLUX" }
#
#         it "maps the hd_type to HD" do
#           session = SavePatientSession.new(
#             patient,
#             payload.session_nodes[0],
#             transmission_log
#           ).call
#
#           expect(session.document.info.hd_type).to eq(:hd)
#
#         end
#        end
