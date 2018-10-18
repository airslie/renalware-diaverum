# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Errors
      class SessionError < StandardError; end
      class DiaverumXMLParsingError < SessionError; end
      class AccessMapError < SessionError; end
      class HDTypeMapError < SessionError; end
      class SessionInvalidError < SessionError; end
      class DialysateNotFoundError < SessionError; end
      class DialysateMissingError < SessionError; end
    end
  end
end
