# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    RSpec.describe Outgoing::PatientQuery do
      include PatientsSpecHelper
      subject(:query) { described_class.new(local_patient_id: local_hospital_id).call }

      context "when there local_patient_id is missing" do
        let(:local_hospital_id) { nil }

        it { is_expected.to be_nil }
      end

      context "when a local_patient_id is passed" do
        context "when the patient is not found" do
          let(:local_hospital_id) { "not_real" }

          it { is_expected.to be_nil }
        end

        context "when patient is found" do
          let(:local_hospital_id) { "123" }
          let!(:patient) do
            create(:hd_patient, local_patient_id: local_hospital_id) do |pat|
              set_modality(
                patient: pat,
                modality_description: create(:hd_modality_description)
              )
            end
          end

          context "when they have no hd profile" do
            it { is_expected.to be_nil }
          end

          context "when they have an HD profile" do
            context "when the profile has no hospital_unit" do
              before do
                create(:hd_profile, patient: patient, hospital_unit: nil)
              end

              it { is_expected.to be_nil }
            end

            context "when they dialyse elsewhere" do
              let(:hospital_unit) { create(:hospital_unit, unit_code: "NOTDIAVERUM") }
              before do
                create(:hd_profile, patient: patient, hospital_unit: hospital_unit)
              end

              it { is_expected.to be_nil }
            end

            context "when they dialyse at a Diaverum unit" do
              let(:hospital_unit) { create(:hospital_unit, unit_code: "DIAVERUM") }

              before do
                create(:hd_profile, patient: patient, hospital_unit: hospital_unit)
                Diaverum::DialysisUnit.create!(hospital_unit: hospital_unit)
              end

              it { is_expected.to eq(patient) }

              context "when they don't have the HD modality" do
                before do
                  set_modality(
                    patient: patient,
                    modality_description: create(:pd_modality_description)
                  )
                end

                it { is_expected.to be_nil }
              end
            end
          end
        end
      end
    end
  end
end
