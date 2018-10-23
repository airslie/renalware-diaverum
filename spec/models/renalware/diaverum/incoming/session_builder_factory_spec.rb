# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      RSpec.describe SessionBuilderFactory do
        context "when the Diaverum XML treatment node has a start time" do
          it "returns a ClosedSessionBuilder instance" do
            args = {
              treatment_node: instance_double(SessionXmlDocument, StartTime: "13:00"),
              user: instance_double(User),
              patient: instance_double(Patient)
            }

            builder = described_class.builder_for(**args)

            expect(builder).to be_kind_of(Renalware::Diaverum::Incoming::ClosedSessionBuilder)
          end
        end

        context "when the Diaverum XML treatment node has NO start time" do
          it "returns a DNASessionBuilder instance" do
            args = {
              treatment_node: instance_double(SessionXmlDocument, StartTime: nil),
              user: instance_double(User),
              patient: instance_double(Patient)
            }

            builder = described_class.builder_for(**args)

            expect(builder).to be_kind_of(Renalware::Diaverum::Incoming::DNASessionBuilder)
          end
        end
      end
    end
  end
end
