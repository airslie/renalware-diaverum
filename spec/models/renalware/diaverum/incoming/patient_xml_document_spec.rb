# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      describe PatientXmlDocument do
        subject { described_class.new(xml) }

        describe ".root" do
          context "when the root element is not 'Patients'" do
            let(:xml) { Nokogiri::XML("<Fish></Fish>") }

            it { expect{ subject }.to raise_error(DiaverumXMLParsingError) }
          end
        end

        context "when there are no Patient elements" do
          let(:xml) { Nokogiri::XML("<Patients></Patients>") }

          it { expect{ subject }.to raise_error(DiaverumXMLParsingError) }
        end

        context "when there are > 1 Patient elements" do
          let(:xml) { Nokogiri::XML("<Patients><Patient/><Patient/></Patients>") }

          it { expect{ subject }.to raise_error(DiaverumXMLParsingError) }
        end

        context "when there is 1 Patient element" do
          let(:xml) { Nokogiri::XML("<Patients><Patient/></Patients>") }

          it { expect{ subject }.not_to raise_error }
        end

        # TODO: test SessionXmlDocument.external_id
      end
    end
  end
end
