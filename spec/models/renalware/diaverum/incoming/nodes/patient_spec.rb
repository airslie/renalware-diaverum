# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      describe Nodes::Patient do
        subject(:document) { described_class.new(xml) }

        describe "#current_dialysis_prescription" do
          subject { document.current_dialysis_prescription }

          let(:xml) do
            Nokogiri::XML(<<-XML)
            <Patients>
              <Patient>
                <DialysisPrescriptions>
                  <DialysisPrescription>
                    <StartDate>2017-06-06</StartDate>
                    <EndDate>2018-06-06</EndDate>
                  </DialysisPrescription>
                  </DialysisPrescription>
                    <StartDate>2018-06-06</StartDate>
                    <EndDate>2999-12-31</EndDate>
                  <DialysisPrescription>
                </DialysisPrescriptions>
              </Patient>
            </Patients>
            XML
          end

          it "" do
            subject
          end
        end
      end
    end
  end
end
