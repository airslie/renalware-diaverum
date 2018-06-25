require "rails_helper"
require "equivalent-xml"

module Renalware
  module Diaverum
    RSpec.describe Outgoing::RenderPatientXml do
      include PatientsSpecHelper

      let(:expected_xml) {
        xml = <<-XML
        <Patients>
          <Patient>
            <LastName>#{patient.family_name}</LastName>
            <FirstName>#{patient.given_name}</FirstName>
            <HospitalNumber>#{patient.local_patient_id}</HospitalNumber>
            <ExternalPatientId>#{patient.nhs_number}</ExternalPatientId>
            <DateOfBirth>1955-10-18</DateOfBirth>
            <Sex>M</Sex>
            <ModalityTypeId/>
            <ModalityTypeDescription/>
            <PrimaryRenalDiagnosisCodeId/>
            <PrimaryRenalDiagnosisCodeDescription/>
            <RaceId/>
            <RaceDescription/>
            <Height>123.0</Height>
            <ResponsiblePhysicianID/>
            <ResponsiblePhysicianLastName/>
            <ResponsiblePhysicianFirstName/>
            <FirstDialysis/>
            <FirstRenalDialysis/>
            <StreetAddress/>
            <Postcode/>
            <City/>
            <PatientStatus/>
          </Patient>
        </Patients>
        XML
        Nokogiri::XML(xml)
      }

      let(:hd_modality_description) { create(:hd_modality_description) }
      let(:hospital_unit) { create(:hospital_unit, unit_code: hospital_unit_code) }
      let(:hospital_unit_code) { "THM" }
      let(:patient) do
        create(:hd_patient, born_on: "18-10-1955").tap do |patient|
          set_modality(patient: patient, modality_description: hd_modality_description)
          create(:hd_profile, hospital_unit: hospital_unit, patient: patient)
          create(:clinic_visit, patient: Renalware::Clinics.cast_patient(patient), height: 1.23)
        end
      end

      describe "#call" do
        it "renders patient XML correctly" do
          actual_xml = Nokogiri::XML(described_class.new(patient).call)

          expect(actual_xml).to be_equivalent_to(expected_xml)
        end
      end
    end
  end
end
