# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    # Maps the combination of DiaverumLocationId (eg LHRU) to a side (left or right) and
    # a Renalware AccessType.
    class HDTypeMap < ApplicationRecord
      def self.for(diaverum_type_id:)
        find_by!(diaverum_type_id: diaverum_type_id).hd_type.to_sym
      rescue ActiveRecord::RecordNotFound
        raise Errors::HDTypeMapError, diaverum_type_id
      end
    end
  end
end
