# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    RSpec.describe HDTypeMap do
      it { is_expected.to have_db_index(:diaverum_type_id) }

      describe ".for" do
        context "when no matching access found" do
          it "raises an error" do
            expect{
              HDTypeMap.for(diaverum_type_id: nil)
            }.to raise_error(Errors::HDTypeMapError)
          end
        end

        context "when a match is found" do
          it "returns the map" do
            create(:hd_type_map, :hd)

            expect(HDTypeMap.for(diaverum_type_id: "HFLUX")).to eq(:hd)
          end
        end
      end
    end
  end
end
