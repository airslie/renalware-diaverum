# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      # Wraps an incoming Treatment XML node
      class SessionXmlDocument
        pattr_initialize :node
        delegate :xpath, to: :node

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

        # Return true if the method name is camel case eg DialysateFlow
        def respond_to_missing?(name, _include_private)
          first_char = name.to_s[0]
          first_char.upcase == first_char
        end

        delegate :to_xml, to: :node
      end
    end
  end
end
