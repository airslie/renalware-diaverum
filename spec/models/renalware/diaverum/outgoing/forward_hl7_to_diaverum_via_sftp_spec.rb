# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    RSpec.describe Outgoing::ForwardHl7ToDiaverumViaSftp do
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
        Transmission.create!(
          direction: :out,
          format: :hl7,
          payload: "MSH..",
          patient: patient
        )
      end

      before do
        Renalware::Diaverum.configure do |config|
          diaverum_path = Rails.root.join("tmp", "diaverum")
          config.diaverum_outgoing_path = diaverum_path.join("out").to_s
          config.diaverum_outgoing_archive_path = diaverum_path.join("out_archive").to_s
          FileUtils.mkdir_p config.diaverum_outgoing_path
          FileUtils.mkdir_p config.diaverum_outgoing_archive_path
        end
      end

      it "creates HL7 files in the diaverum 'out' and 'out archive' folders" do
        allow_any_instance_of(Outgoing::Hl7Filename).to receive(:to_s).and_return("example.hl7")

        travel_to(time) do
          allow(File).to receive(:write).twice

          service.call

          expect(File).to have_received(:write).twice

          transmission.reload

          expect(transmission.transmitted_at).to eq(time)
          expect(transmission.filepath).to eq(
            File.join(Renalware::Diaverum.config.diaverum_outgoing_path, "example.hl7")
          )
        end
      end
    end
  end
end
