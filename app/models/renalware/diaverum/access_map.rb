# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    # Maps the combination of DiaverumLocationId (eg LHRU) to a side (left or right) and
    # a Renalware AccessType.
    class AccessMap < ApplicationRecord
      belongs_to :access_type

      def self.for(diaverum_location:, diaverum_type:)
        find_by!(
          diaverum_location_id: diaverum_location,
          diaverum_type_id: diaverum_type
        )
      end
    end
  end
end
