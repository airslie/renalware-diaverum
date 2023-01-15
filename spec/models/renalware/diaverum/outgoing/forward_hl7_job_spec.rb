# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    RSpec.describe Outgoing::ForwardHL7Job do
      it "delegates to ForwardHL7ToDiaverumViaSFTP" do
        allow(Outgoing::ForwardHL7ToDiaverumViaSFTP).to receive(:call)

        expect(described_class.new.perform(transmission: nil))

        expect(Outgoing::ForwardHL7ToDiaverumViaSFTP).to have_received(:call)
      end
    end
  end
end
