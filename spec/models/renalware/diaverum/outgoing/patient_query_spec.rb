# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    RSpec.describe Outgoing::PatientQuery do
      include PatientsSpecHelper
      subject(:query) { described_class.new(local_patient_id: local_hospital_id).call }

      let(:provider) { HD::Provider.new(name: "Diaverum") }

      context "when a nil local_patient_id argument is passed" do
        let(:local_hospital_id) { nil }

        it { is_expected.to be_nil }
      end

      context "when a local_patient_id is passed" do
        context "when the patient is not found" do
          let(:local_hospital_id) { "hosp id of patient not on the system" }

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
              let(:hospital_unit) { create(:hospital_unit) }
              before do
                create(:hd_profile, patient: patient, hospital_unit: hospital_unit)
                # NB: No HD::ProviderUnit setup, so hospital_unit is not associated with
                # the Diavarum provider via ProviderUnit
              end

              it { is_expected.to be_nil }
            end

            context "when they dialyse at a Diaverum unit" do
              let(:hospital_unit) { create(:hospital_unit) }

              before do
                create(:hd_profile, patient: patient, hospital_unit: hospital_unit)

                # Associate the hosp unit with the Diavarum provider via ProviderUnit
                HD::ProviderUnit.create!(hospital_unit: hospital_unit, hd_provider: provider)
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
