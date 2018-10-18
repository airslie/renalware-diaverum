# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      # Wraps an incoming Treatment XML node
      class SessionXmlDocument
        pattr_initialize :node
        delegate :xpath, to: :node

        # Most node attributes and handled in method_missing but StartTime is
        # a special case because we want to stub in tests and it therefore needs to be
        # on the object's interface.
        # rubocop:disable Naming/MethodName
        def StartTime
          node.xpath("StartTime")&.text
        end
        # rubocop:enable Naming/MethodName

        # Delegate methods names in CamelCase to the decorated XML Treatment node
        # so we can use e.g. session_xml_doc.TreatmentId
        def method_missing(method, *args, &block)
          first_char = method.to_s[0]
          if first_char.upcase == first_char
            node.xpath(method.to_s)&.text
          else
            super(method, *args, block)
          end
        end

        delegate :to_xml, to: :node
      end
    end
  end
end
