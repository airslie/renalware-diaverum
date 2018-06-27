# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      # Forward an HL7 pathology message to Diaverum
      class ForwardHl7Job < ::ApplicationJob
        def perform(transmission:)
          ForwardHl7ToDiaverumViaSftp.new(transmission: transmission).call
        end
      end
    end
  end
end
