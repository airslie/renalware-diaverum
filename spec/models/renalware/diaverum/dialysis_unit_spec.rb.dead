# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    RSpec.describe DialysisUnit do
      it { is_expected.to belong_to(:hospital_unit) }
      it { is_expected.to validate_presence_of(:hospital_unit) }
      it { is_expected.to validate_presence_of(:diaverum_clinic_id) }
    end
  end
end
