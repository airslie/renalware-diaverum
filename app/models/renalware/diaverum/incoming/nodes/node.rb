# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      module Nodes
        # Wraps an incoming Prescription XML node
        class Node
          pattr_initialize :node
          delegate :xpath, :to_xml, to: :node

          # Delegate methods names in CamelCase to the decorated XML Treatment node
          # so we can use e.g. session_xml_doc.TreatmentId
          def method_missing(method, *args, &block)
            first_char = method.to_s[0]
            if first_char.upcase == first_char
              node.xpath(method.to_s)&.text
            else
              super
            end
          end

          # Return true if the method name is camel case eg DialysateFlow
          def respond_to_missing?(name, _include_private)
            first_char = name.to_s[0]
            first_char.upcase == first_char
          end
        end
      end
    end
  end
end
