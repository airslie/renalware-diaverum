# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      module Nodes
        # Wraps an incoming Patient XML node
        class Patients < Node
          def one_and_only_patient_node
            nodes = xpath("Patient")
            if nodes.count == 0
              raise(Errors::DiaverumXMLParsingError, "Patient node not found")
            end

            if nodes.length > 1
              raise(
                Errors::DiaverumXMLParsingError,
                "#{nodes.count} Patient elements - expected one"
              )
            end

            Nodes::Patient.new(nodes.first)
          end
        end
      end
    end
  end
end
