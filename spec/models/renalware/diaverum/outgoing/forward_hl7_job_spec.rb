# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    RSpec.describe Outgoing::ForwardHl7Job do
      it "delegates to ForwardHl7ToDiaverumViaSftp" do
        allow(Outgoing::ForwardHl7ToDiaverumViaSftp).to receive(:call)

        expect(described_class.new.perform(transmission: nil))

        expect(Outgoing::ForwardHl7ToDiaverumViaSftp).to have_received(:call)
      end
    end
  end
end
