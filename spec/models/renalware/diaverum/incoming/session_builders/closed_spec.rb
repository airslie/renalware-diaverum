# frozen_string_literal: true

# rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
require "rails_helper"

# we want to test that
# a) values are mapped correctly
# b) validation works if value missing or out of range
module Renalware
  module Diaverum
    module Incoming
      RSpec.describe SessionBuilders::Closed do
        include DiaverumHelpers

        let(:user) { create(:user) }
        let(:patient) { build(:hd_patient, local_patient_id: "KCH123", nhs_number: "0123456789") }
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
        let(:dialysate) { create(:hd_dialysate) }
        let(:provider) { HD::Provider.create!(name: "Diaverum") }
        let(:access_type) { create(:access_type) }

        describe ".call" do
          before do
            create_access_map
            create_hd_type_map
            create_dry_weight
          end

          it "builds a valid Session::Closed object" do
            session = described_class.call(
              patient: patient,
              treatment_node: treatment_node,
              user: user,
              patient_node: patient_node
            )
            document = session.document

            expect(session.class.name).to eq("Renalware::HD::Session::Closed")

            # Notes are a combination of Treatment/Notes and JournalEntries/JournalEntry
            # matching that date
            expected_notes = "Some session notes"
            expected_notes += "\n#{treatment_node.Date} Daily Notes/General: "\
                              "Fistula cannulated with no complaints"
            expected_notes += "\n#{treatment_node.Date} Treatment Notes/XYZ: "\
                              "Some treatment notes"

            expect(session).to have_attributes(
              patient: patient,
              hospital_unit: hospital_unit,
              started_at: Time.zone.parse("#{treatment_node.Date} #{treatment_node.StartTime}"),
              stopped_at: Time.zone.parse("#{treatment_node.Date} #{treatment_node.EndTime}"),
              dialysate: dialysate,
              external_id: treatment_node.TreatmentId.to_i,
              created_by: user,
              updated_by: user,
              signed_on_by: user,
              signed_off_by: user,
              signed_off_at: Time.zone.parse("#{treatment_node.Date} #{treatment_node.EndTime}"),
              notes: expected_notes
            )

            expect(session.start_time.to_s).to include(treatment_node.StartTime)
            expect(session.end_time.to_s).to include(treatment_node.EndTime)
            expect(session.dry_weight).to be_present

            expect(document.info).to have_attributes(
              hd_type: "hd",
              machine_no: treatment_node.MachineIdentifier,
              access_confirmed: true,
              access_type: access_type.name,
              access_type_abbreviation: access_type.abbreviation,
              access_side: "left"
            )

            dialysis = document.dialysis
            expect(dialysis).to have_attributes(
              arterial_pressure: treatment_node.ArterialPressure.to_i,
              venous_pressure: treatment_node.VenousPressure.to_i,
              fluid_removed: treatment_node.RemovedVolume.to_f,
              blood_flow: treatment_node.Bloodflow.to_i,
              flow_rate: treatment_node.DialysateFlow.to_i,
              machine_urr: nil,
              machine_ktv: treatment_node.KTV,
              litres_processed: treatment_node.TreatedBloodVolume.to_f
            )

            pre = document.observations_before
            expect(pre.pulse.to_s).to eq(treatment_node.PulsePre)
            expect(pre.blood_pressure.systolic.to_s)
              .to eq(treatment_node.SystolicBloodPressurePre)
            expect(pre.blood_pressure.diastolic.to_s)
              .to eq(treatment_node.DiastolicBloodPressurePre)
            expect(pre.weight_measured).to eq(:yes)
            expect(pre.weight).to eq(84.5)
            expect(pre.temperature_measured).to eq(:yes)
            expect(pre.temperature).to eq(35.6)
            expect(pre.respiratory_rate_measured).to eq(:no)

            post = document.observations_after
            expect(post.pulse.to_s).to eq(treatment_node.PulsePost)
            expect(post.blood_pressure.systolic.to_s)
              .to eq(treatment_node.SystolicBloodPressurePost)
            expect(post.blood_pressure.diastolic.to_s).to eq(
              treatment_node.DiastolicBloodPressurePost
            )
            expect(post.weight_measured).to eq(:yes)
            expect(post.weight).to eq(83.6)
            expect(post.temperature_measured).to eq(:yes)
            expect(post.temperature).to eq(35.4)
            expect(post.temperature).to eq(35.4)
            expect(post.respiratory_rate_measured).to eq(:no)

            expect(document.hdf.subs_volume).to eq(124.0)
            expect(document.complications.line_exit_site_status).to eq("99") # n/a
            expect(document.avf_avg_assessment.score).to eq("99") # n/a
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
