# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    RSpec.describe Outgoing::Hl7Filename do
      let(:patient) do
        Patient.new(born_on: "01-12-2000", nhs_number: "0123456789", local_patient_id: "kch1")
      end
      let(:message) { Feeds::Message.new }
      let(:time) { Time.zone.parse("11-12-2000 01:02:03") }

      describe ".to_s" do
        subject { described_class.new(patient: patient, message: message).to_s }

        it {
          travel_to(time) do
            is_expected.to eq("20001211010203_0123456789_KCH1_20001201.hl7")
          end
        }
      end
    end
  end
end
