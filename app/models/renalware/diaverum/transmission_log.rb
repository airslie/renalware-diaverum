# frozen_string_literal: true

module Renalware
  module Diaverum
    class TransmissionLog < ApplicationRecord
      belongs_to :dialysis_unit, class_name: "Diaverum::DialysisUnit"
      belongs_to :patient
      validates :patient, presence: true
      validates :format, presence: true # :xml :hl7
      validates :direction, presence: true # :in :out
    end
  end
end
