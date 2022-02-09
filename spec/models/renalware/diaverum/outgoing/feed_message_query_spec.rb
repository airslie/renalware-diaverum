# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    RSpec.describe Outgoing::FeedMessagesQuery do
      include PatientsSpecHelper

      let(:hospital_unit) { create(:hospital_unit) }

      before do
        HD::ProviderUnit.create!(
          hospital_unit: hospital_unit,
          hd_provider: HD::Provider.new(name: "Diaverum")
        )
      end

      def diaverum_patient(nhs_number:, local_patient_id:)
        patient = create(
          :hd_patient,
          nhs_number: nhs_number,
          local_patient_id: local_patient_id
        )
        set_modality(
          patient: patient,
          modality_description: create(:hd_modality_description)
        )
        create(:hd_profile, patient: patient, hospital_unit: hospital_unit)
        patient
      end

      def create_feed_msg(date:, nhs_number: nil, local_patient_id: "" )
        Renalware::Feeds::Message.create!(
          header_id: "#{nhs_number}#{local_patient_id},#{date}",
          event_code: "ORU^R01",
          body: "-",
          patient_identifier: nhs_number,
          patient_identifiers: { "PAS Number" => local_patient_id },
          created_at: date
        )
      end

      it "matches a patient by nhs number" do
        diaverum_patient(nhs_number: "0921035497", local_patient_id: "unused")
        fm = create_feed_msg(nhs_number: "0921035497", date: "2022-01-01")

        expect(Outgoing::PatientQuery.diaverum_patients.count).to eq(1)
        msgs = described_class.call(from_date: "2022-01-01", to_date: "2022-01-31")

        expect(msgs.size).to eq(1)
        expect(msgs.first).to eq(fm)
      end

      it "matches a patient by local_hospital_id" do
        diaverum_patient(nhs_number: nil, local_patient_id: "123")
        fm = create_feed_msg(local_patient_id: "123", date: "2022-01-01")
        expect(Outgoing::PatientQuery.diaverum_patients.count).to eq(1)

        msgs = described_class.call(from_date: "2022-01-01", to_date: "2022-01-31")

        expect(msgs.size).to eq(1)
        expect(msgs.first).to eq(fm)
      end

      it "returns no msgs when no matches" do
        diaverum_patient(nhs_number: "0921035497", local_patient_id: "123")
        create_feed_msg(date: "2022-01-01")

        msgs = described_class.call(from_date: "2022-01-01", to_date: "2022-01-31")

        expect(msgs.size).to eq(0)
      end

      it "returns only messages with the search range" do
        diaverum_patient(nhs_number: "0921035497", local_patient_id: "123")
        seeds = [
          create_feed_msg(local_patient_id: "123", date: "2022-12-31 23:59:59"),
          create_feed_msg(local_patient_id: "123", date: "2022-01-01 00:00:01"),
          create_feed_msg(local_patient_id: "123", date: "2022-01-31 23:59:59"),
          create_feed_msg(local_patient_id: "123", date: "2022-02-01 00:00:01")
        ]

        msgs = described_class.call(from_date: "2022-01-01", to_date: "2022-01-31")

        expect(msgs.sort_by(&:id)).to eq([seeds[1], seeds[2]])
      end
    end
  end
end
