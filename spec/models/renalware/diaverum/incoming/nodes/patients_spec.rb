# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      describe Nodes::Patients do
        describe "#one_and_only_patient_node" do
          subject(:document) { described_class.new(xml).one_and_only_patient_node }

          context "when there are no Patient elements" do
            let(:xml) { Nokogiri::XML("<Patients></Patients>").root }

            it "raises an error" do
              expect { subject }.to raise_error(
                Errors::DiaverumXMLParsingError,
                "Patient node not found"
              )
            end
          end

          context "when there are is a Patient element" do
            let(:xml) { Nokogiri::XML("<Patients><Patient></Patient></Patients>").root }

            it { is_expected.to be_a(Nodes::Patient) }
          end

          context "when there is > 1 Patient element" do
            let(:xml) {
              Nokogiri::XML("<Patients><Patient></Patient><Patient></Patient></Patients>").root
            }

            it "raises an error" do
              expect { subject }.to raise_error(
                Errors::DiaverumXMLParsingError,
                "2 Patient elements - expected one"
              )
            end
          end
        end
      end
    end
  end
end
