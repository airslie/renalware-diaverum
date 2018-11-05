# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      RSpec.describe SavePatientSession do
        include DiaverumHelpers
        include Diaverum::ConfigurationHelpers
      end
    end
  end
end
