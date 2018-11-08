# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      RSpec.describe SaveSession do
        include DiaverumHelpers
        include Diaverum::ConfigurationHelpers
        subject(:service) do
          described_class.new(
            patient: patient,
            treatment_node: treatment_node,
            log: log,
            patient_node: patient_node
          )
        end
        let(:patient) { nil }
        let(:treatment_node) { nil }
        let(:log) { nil }
        let(:patient_node) { nil }

        context "when a Treatment has a Date before diaverum_go_live_date" do
          let(:treatment_node) {
            instance_double(
              Nodes::Treatment,
              Date: Time.zone.today - 1.day,
              TreatmentId: "123"
            )
          }

          it "does not import it" do
            allow(Diaverum.config).to receive(:diaverum_go_live_date).and_return(Time.zone.today)
            result = nil

            expect {
              result = subject.call
            }.to change(HD::Session, :count).by(0)

            expect(result).to eq(nil)
          end
        end

        context "when a Treatment has a Date after diaverum_go_live_date" do
          it "a bit hard to test just now"
        end
      end
    end
  end
end
