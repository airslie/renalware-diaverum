# frozen_string_literal: true

module Renalware
  module Diaverum
    # Can represent incoming or outgoing diaverum events.
    # If outgoing, represents an attempt to send an HL7 message to Diaverum
    # If incoming, represents an attempt to import an XML file of sessions from Diaverum
    class Transmission < ApplicationRecord
      belongs_to :dialysis_unit, class_name: "Diaverum::DialysisUnit"
      belongs_to :patient
      validates :format, presence: true # :xml :hl7
      validates :direction, presence: true # :in :out
    end
  end
end
