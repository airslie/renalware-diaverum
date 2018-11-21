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
            parent_log: log,
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
            allow(Diaverum.config)
              .to receive(:diaverum_go_live_date).and_return(Time.zone.today)
            allow(Diaverum.config)
              .to receive(:diaverum_incoming_skip_session_save).and_return(false)
            result = nil

            expect {
              result = subject.call
            }.to change(HD::Session, :count).by(0)

            expect(result).to eq(nil)
          end
        end

        context "when a Treatment has a Date after diaverum_go_live_date" do
          let(:treatment_node) {
            instance_double(
              Nodes::Treatment,
              Date: Time.zone.today,
              TreatmentId: "123",
              requires_deletion?: false,
              to_xml: ""
            )
          }
          let(:log) { NullObject.instance }

          it "saves it" do
            allow(Diaverum.config)
              .to receive(:diaverum_go_live_date).and_return(Time.zone.today - 1.year)
            allow(Diaverum.config)
              .to receive(:diaverum_incoming_skip_session_save).and_return(false)
            allow(Renalware::SystemUser)
              .to receive(:find).and_return(NullObject.instance)
            allow(Renalware::HD::Session)
              .to receive(:select).and_return(double(find_by: nil))
            session = HD::Session::Closed.new
            allow(session).to receive(:save!)
            builder = instance_double(SessionBuilders::Closed, call: session)
            allow(SessionBuilders::Factory).to receive(:builder_for).and_return(builder)

            subject.call

            expect(session).to have_received(:save!)
          end
        end
      end
    end
  end
end
