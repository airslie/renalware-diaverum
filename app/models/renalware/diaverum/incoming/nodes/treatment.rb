# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      module Nodes
        # Wraps an incoming Treatment XML node
        class Treatment < Node
          # Most node attributes and handled in method_missing but StartTime and DialysateFlow are
          # special cases because we want to stub in tests and they therefore needs to be
          # on the object's interface.
          # rubocop:disable Naming/MethodName
          def StartTime
            node.xpath("StartTime")&.text
          end

          def DialysateFlow
            node.xpath("DialysateFlow")&.text
          end

          def Deleted
            node.xpath("Deleted")&.text
          end

          def TreatmentId
            node.xpath("TreatmentId")&.text
          end
          # rubocop:enable Naming/MethodName
        end
      end
    end
  end
end
