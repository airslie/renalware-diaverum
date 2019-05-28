# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    RSpec.describe Outgoing::Hl7Filename do
      let(:patient) do
        Patient.new(born_on: "01-12-2000", nhs_number: "0123456789", local_patient_id: "kch1")
      end

      let(:time) {
        Time.zone.strptime("2000-12-11 01:02:03.000", "%Y-%m-%d %H:%M:%S.%N")
      }

      describe ".to_s" do
        subject { described_class.new(patient: patient).to_s }

        it {
          travel_to(time) do
            expect(subject).to eq("20001211010203000_0123456789_KCH1_20001201.hl7")
          end
        }
      end
    end
  end
end
