# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    class PatientsQuery
      pattr_initialize :hospital_unit

      def self.call(*args)
        new(*args).call
      end

      def call
        HD::Patient
          .eager_load(:hd_profile)
          .where("hd_profiles.hospital_unit_id = ?", hospital_unit.id) # id = 16 unit_code 'THM'
          .extending(Renalware::ModalityScopes)
          .with_current_modality_matching("HD")
      end
    end
  end
end
