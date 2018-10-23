# frozen_string_literal: true

require "rails_helper"

# we want to test that
# a) values are mapped correctly
# b) validation works if value missing or out of range
module Renalware
  module Diaverum
    module Incoming
      RSpec.describe ClosedSessionBuilder do
        include DiaverumHelpers

        let(:user) { create(:user) }
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

          context "when StartTime is present" do
            it "builds a new Closed Session object" do
              session = described_class.call(
                patient: patient,
                treatment_node: treatment_node,
                user: user
              )

              expect(session.class.name).to eq("Renalware::HD::Session::Closed")

              expect(session).to have_attributes(
                patient: patient,
                hospital_unit: hospital_unit,
                performed_on: Date.parse(treatment_node.Date),
                notes: treatment_node.Notes,
                dialysate: dialysate,
                external_id: treatment_node.TreatmentId.to_i,
                created_by: user,
                updated_by: user,
                signed_on_by: user,
                signed_off_by: user,
                signed_off_at: Time.zone.parse("#{treatment_node.Date} #{treatment_node.EndTime}")
              )

              expect(session.start_time.to_s).to include(treatment_node.StartTime)
              expect(session.end_time.to_s).to include(treatment_node.EndTime)
              expect(session.dry_weight).to be_present

              info = session.document.info
              expect(info).to have_attributes(
                hd_type: "hd",
                machine_no: treatment_node.MachineIdentifier,
                access_confirmed: true,
                access_type: access_type.name,
                access_type_abbreviation: access_type.abbreviation,
                access_side: "left"
              )

              dialysis = session.document.dialysis
              expect(dialysis.arterial_pressure.to_s).to eq(treatment_node.ArterialPressure)
              expect(dialysis.venous_pressure.to_s).to eq(treatment_node.VenousPressure)
              expect(dialysis.fluid_removed.to_s).to eq(treatment_node.RemovedVolume)
              expect(dialysis.blood_flow.to_s).to eq(treatment_node.Bloodflow)
              expect(dialysis.flow_rate.to_s).to eq(treatment_node.DialysateFlow)
              expect(dialysis.machine_urr).to be_nil
              expect(dialysis.machine_ktv.to_s).to eq(treatment_node.KTV)
              expect(dialysis.litres_processed.to_s).to eq(treatment_node.TreatedBloodVolume)

              pre = session.document.observations_before
              expect(pre.pulse.to_s).to eq(treatment_node.PulsePre)
              expect(pre.blood_pressure.systolic.to_s)
                .to eq(treatment_node.SystolicBloodPressurePre)
              expect(pre.blood_pressure.diastolic.to_s)
                .to eq(treatment_node.DiastolicBloodPressurePre)
              expect(pre.weight_measured).to eq(:yes)
              expect(pre.weight).to eq(84.5)
              expect(pre.temperature_measured).to eq(:yes)
              expect(pre.temperature).to eq(35.6)

              post = session.document.observations_after
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

              hdf = session.document.hdf
              expect(hdf.subs_volume).to eq(124.0)
            end
          end
        end
      end
    end
  end
end
