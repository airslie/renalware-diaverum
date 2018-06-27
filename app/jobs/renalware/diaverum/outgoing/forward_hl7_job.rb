# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      # Forward an HL7 pathology message to Diaverum
      class ForwardHl7Job < ::ApplicationJob
        def perform(transmission:)
          # Could use another forwarding method eg Mirth in the future
          # but for now its just SFTP
          ForwardHl7ToDiaverumViaSftp.new(transmission).call
        end
      end
    end
  end
end
