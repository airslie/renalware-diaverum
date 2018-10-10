# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Errors
      class DiaverumXMLParsingError < StandardError; end
      class AccessMapError < StandardError; end
      class HDTypeMapError < StandardError; end
      class SessionInvalidError < StandardError; end
      class DialysateNotFoundError < StandardError; end
      class DialysateMissingError < StandardError; end
    end
  end
end
