# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      RSpec.describe SessionBuilders::Factory do
        context "when the Diaverum XML treatment node has a start time" do
          it "returns a SessionBuilders::Closed instance" do
            args = {
              treatment_node: instance_double(Nodes::Treatment, StartTime: "13:00"),
              user: instance_double(User),
              patient: instance_double(Patient),
              patient_node: instance_double(Nodes::Patient)
            }

            builder = described_class.builder_for(**args)

            expect(builder).to be_kind_of(Renalware::Diaverum::Incoming::SessionBuilders::Closed)
          end
        end

        context "when the Diaverum XML treatment node has NO start time" do
          it "returns a SessionBuilders::DNA instance" do
            args = {
              treatment_node: instance_double(Nodes::Treatment, StartTime: nil),
              user: instance_double(User),
              patient: instance_double(Patient),
              patient_node: instance_double(Nodes::Patient)
            }

            builder = described_class.builder_for(**args)

            expect(builder).to be_kind_of(Renalware::Diaverum::Incoming::SessionBuilders::DNA)
          end
        end
      end
    end
  end
end
