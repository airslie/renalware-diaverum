# frozen_string_literal: true

require "rails_helper"

# we want to test that
# a) values are mapped correctly
# b) validation works if value missing or out of range
module Renalware
  module Diaverum
    module Incoming
      RSpec.describe SessionBuilders::DNA do
        include DiaverumHelpers

        let(:user) { create(:user) }
        let(:patient) { build(:hd_patient, local_patient_id: "KCH123", nhs_number: "0123456789") }
        let(:treatment_node) { nil }
        let(:xml_filepath) { file_fixture("diaverum_example.xml.erb") }
        let(:patient_node) { Nodes::Patient.new(doc) }
        let(:doc) do
          # Set up an erb template based on the XML fixture so we can insert patient identifiers
          # into the XML.By magic, the patient variable is in binding so can be resolved in
          # the ERB template
          xml = ERB.new(xml_filepath.read).result(binding)
          Nokogiri::XML(xml)
        end
        let(:treatment_node) { patient_node.treatment_nodes.first }
        let(:hospital_unit) { create(:hospital_unit) }
        let(:dialysis_unit) do
          HD::ProviderUnit.create!(
            hospital_unit: hospital_unit,
            hd_provider: provider,
            providers_reference: "123"
          )
        end
        let(:provider) { HD::Provider.create!(name: "Diaverum") }

        describe ".call" do
          it "builds a valid Session::DNA object" do
            session = described_class.call(
              patient: patient,
              treatment_node: treatment_node,
              user: user,
              patient_node: patient_node
            )

            expect(session.class.name).to eq("Renalware::HD::Session::DNA")

            expect(session).to have_attributes(
              patient: patient,
              hospital_unit: hospital_unit,
              performed_on: treatment_node.Date,
              external_id: treatment_node.TreatmentId.to_i,
              created_by: user,
              updated_by: user
            )

            # Notes are a combination of Treatment/Notes and JournalEntries/JournalEntry
            # matching that date
            expected_notes = "Some session notes"
            expected_notes += "\n#{treatment_node.Date} Daily Notes/General: "\
                              "Fistula cannulated with no complaints"
            expected_notes += "\n#{treatment_node.Date} Treatment Notes/XYZ: "\
                              "Some treatment notes"

            expect(session.notes).to eq(expected_notes)
            expect(session).to be_valid
          end
        end
      end
    end
  end
end
