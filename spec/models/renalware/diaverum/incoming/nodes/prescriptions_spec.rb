# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      module Nodes
        describe Prescriptions do
          subject(:prescriptions) { described_class.new(xml.root) }

          describe "attributes" do
            let(:xml) do
              Nokogiri::XML(<<-XML)
              <DialysisPrescriptions>
                <DialysisPrescription>
                  <StartDate>2018-06-01</StartDate>
                  <EndDate>2018-07-12</EndDate>
                </DialysisPrescription>
                <DialysisPrescription>
                  <StartDate>2018-07-12</StartDate>
                  <EndDate>2999-12-31</EndDate>
                </DialysisPrescription>
                <DialysisPrescription>
                  <StartDate>2998-01-01</StartDate>
                  <EndDate>2999-12-31</EndDate>
                </DialysisPrescription>
              </DialysisPrescriptions>
              XML
            end

            describe "#children" do
              it "should have the correct number of child prescription" do
                expect(prescriptions.children.count).to eq(3)
              end

              it "prescriptions should be of type Nodes::Prescription" do
                expect(prescriptions.children.first.class).to eq(
                  Renalware::Diaverum::Incoming::Nodes::Prescription
                )
              end
            end

            describe "current" do
              it "returns the prescription with a future EndDate and a present or past StartDate" do
                expect(prescriptions.current.EndDate).to eq("2999-12-31")
              end
            end
          end
        end
      end
    end
  end
end
