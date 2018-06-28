# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    # Maps the combination of DiaverumLocationId (eg LHRU) to a side (left or right) and
    # a Renalware AccessType.
    class AccessMap < ApplicationRecord
      belongs_to :access_type, class_name: "Renalware::Accesses::Type"

      def self.for(diaverum_location:, diaverum_type:)
        args = {
          diaverum_location_id: diaverum_location,
          diaverum_type_id: diaverum_type
        }
        find_by!(args)
      rescue ActiveRecord::RecordNotFound => e
        raise Errors::AccessMapError, args
      end
    end
  end
end
