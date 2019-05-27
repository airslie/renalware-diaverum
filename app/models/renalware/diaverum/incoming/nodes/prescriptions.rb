# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      module Nodes
        # Wraps an incoming DialysisPrescriptions XML node
        class Prescriptions < Node
          def current
            children.detect(&:active?)
          end

          def children
            @children ||= begin
              xpath("DialysisPrescription").map { |node| Nodes::Prescription.new(node) }
            end
          end
        end
      end
    end
  end
end
