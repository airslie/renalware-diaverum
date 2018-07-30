# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    RSpec.describe AccessMap do
      it { is_expected.to belong_to(:access_type) }
      it { is_expected.to have_db_index([:diaverum_location_id, :diaverum_type_id]) }

      describe ".for" do
        context "when no matching access found" do
          it "raises an error" do
            expect{
              AccessMap.for(diaverum_location: nil, diaverum_type: nil)
            }.to raise_error(Errors::AccessMapError)
          end
        end

        context "when a match is found" do
          it "returns the map" do
            rw_access_type = create(:access_type)
            new_map = AccessMap.create!(
              diaverum_location_id: "x",
              diaverum_type_id: 1,
              access_type_id: rw_access_type.id
            )
            map = AccessMap.for(diaverum_location: "x", diaverum_type: 1)
            expect(map.id).to eq(new_map.id)
          end
        end
      end
    end
  end
end
