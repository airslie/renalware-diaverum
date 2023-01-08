# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    RSpec.describe Outgoing::ForwardHL7ToDiaverumViaSftp do
      subject(:service) { described_class.new(transmission) }

      let(:time) { "2018-01-01 01:01:01" }
      let(:patient) do
        create(
          :patient,
          born_on: "11-12-20018",
          nhs_number: "0123456789",
          local_patient_id: "123"
        )
      end
      let(:transmission) do
        HD::TransmissionLog.create!(
          direction: :out,
          format: :hl7,
          payload: "MSH..",
          patient_id: patient.id
        )
      end

      before do
        Renalware::Diaverum.configure do |_config|
          Paths.setup
        end
      end

      it "creates HL7 files in the diaverum 'out' and 'out archive' folders" do
        allow_any_instance_of(Outgoing::HL7Filename).to receive(:to_s).and_return("example.hl7")

        travel_to(time) do
          allow(File).to receive(:write).twice

          service.call

          expect(File).to have_received(:write).twice

          transmission.reload

          expect(transmission.transmitted_at).to eq(time)
          expect(transmission.filepath).to eq(Paths.outgoing.join("example.hl7").to_s)
        end
      end
    end
  end
end
