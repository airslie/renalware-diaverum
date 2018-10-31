# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      module Nodes
        describe Node do
          subject(:node) { described_class.new(xml.root) }

          let(:xml) do
            Nokogiri::XML(<<-XML)
            <SomeElement>
              <SomeAttribute>TEST</SomeAttribute>
            </SomeElement>
            XML
          end

          it "can call XML elements as if they were methods" do
            expect(node.SomeAttribute).to eq("TEST")
          end
        end
      end
    end
  end
end
