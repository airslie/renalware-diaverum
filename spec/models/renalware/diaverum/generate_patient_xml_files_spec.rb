require "rails_helper"

module Renalware
  RSpec.describe Diaverum::GeneratePatientXmlFiles do
    include PatientsSpecHelper

    subject do
      described_class.new(
        hospital_unit_code: hospital_unit_code,
        destination_path: destination_path
      )
    end

    let(:hospital_unit_code) { "THM" }
    let(:hospital_unit) { create(:hospital_unit, unit_code: hospital_unit_code) }
    let(:destination_path) { Rails.root.join("tmp", "diaverum") }
    let(:hd_modality_description) { create(:hd_modality_description) }
    let(:hd_patient) do
      create(:hd_patient).tap do |patient|
        set_modality(patient: patient, modality_description: hd_modality_description)
      end
    end

    describe "#call" do
      context "when no HD patients are dialysing at the unit" do
        it "does not write any files" do
          hospital_unit
          allow(File).to receive(:write)

          subject.call

          expect(File).to have_received(:write).exactly(0).times
        end
      end

      context "when there is an HD patient dialysing at the unit" do
        before { create(:hd_profile, hospital_unit: hospital_unit, patient: hd_patient) }

        it "writes 1 patient XML file" do
          allow(File).to receive(:write)

          subject.call

          expect(File).to have_received(:write).exactly(1).times
        end
      end
    end
  end
end
