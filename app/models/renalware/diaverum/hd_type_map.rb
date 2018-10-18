# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    # Maps a Diaverum HDType (as found in the XML) from eg HFLUX to :hd, or HDFPO to :hdf_post
    # Diaverum types are for example:
    # HDFPO: HDF-Postdilution => :hdf_post
    # HDFPR: HDF-Predilution => :hdf_post
    # HFPO: HF-Postdilution => :hd
    # HDPR: HF-Predilution => :hd
    # HFUX: High flux hemodialysis => :hd
    # HD: Low flux hemodialysis => :hd
    class HDTypeMap < ApplicationRecord
      def self.for(diaverum_type_id:)
        find_by!(diaverum_type_id: diaverum_type_id).hd_type.to_sym
      rescue ActiveRecord::RecordNotFound
        raise Errors::HDTypeMapError, diaverum_type_id
      end
    end
  end
end
