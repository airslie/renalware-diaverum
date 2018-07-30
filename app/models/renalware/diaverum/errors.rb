# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Errors
      class DiaverumXMLParsingError < StandardError; end
      class AccessMapError < StandardError; end
      class SessionInvalidError < StandardError; end
    end
  end
end
