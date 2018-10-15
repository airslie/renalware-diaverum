# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      # Wraps an incoming Treatment XML node
      class SessionXmlDocument
        pattr_initialize :node
        delegate :xpath, to: :node

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

        def to_xml
          node.to_xml #(indent: 2)
        end
      end
    end
  end
end
