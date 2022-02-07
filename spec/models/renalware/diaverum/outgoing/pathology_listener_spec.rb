# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    RSpec.describe Outgoing::PathologyListener do
      subject(:listener) { described_class }

      it "does nothing if feed_message patient_identifier is blank" do
        feed_message = double(:feed_message, body: "123", patient_identifier: nil)
        allow(Outgoing::ForwardHl7Job).to receive(:perform_later)

        listener.oru_message_processed(feed_message: feed_message)

        expect(Outgoing::ForwardHl7Job).not_to have_received(:perform_later)
      end

      it "does nothing if patient not found" do
        feed_message = double(:feed_message, body: "123", patient_identifier: "XYZ")
        allow(Outgoing::ForwardHl7Job).to receive(:perform_later)

        listener.oru_message_processed(feed_message: feed_message)

        expect(Outgoing::ForwardHl7Job).not_to have_received(:perform_later)
      end

      it "calls ForwardHl7Job if patient found" do
        patient = Patient.new(nhs_number: "9338503739")
        feed_message = double(:feed_message, body: "123", patient_identifier: "9338503739")
        allow_any_instance_of(Outgoing::PatientQuery).to receive(:call).and_return(patient)

        allow(Outgoing::ForwardHl7Job).to receive(:perform_later)

        listener.oru_message_processed(feed_message: feed_message)

        expect(Outgoing::ForwardHl7Job).to have_received(:perform_later) do |args|
          expect(args[:transmission].class).to eq(Renalware::HD::TransmissionLog)
        end
      end
    end
  end
end
