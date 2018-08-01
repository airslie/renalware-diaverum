# frozen_string_literal: true

module Renalware
  module Diaverum
    class DialysisUnit < ApplicationRecord
      belongs_to :hospital_unit, class_name: "Renalware::Hospitals::Unit"
      validates :hospital_unit, presence: true
      validates :diaverum_clinic_id, presence: true
    end
  end
end
