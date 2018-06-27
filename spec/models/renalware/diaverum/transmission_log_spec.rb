# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    RSpec.describe TransmissionLog do
      it { is_expected.to belong_to(:dialysis_unit) }
      it { is_expected.to belong_to(:patient) }
      it { is_expected.to validate_presence_of(:dialysis_unit) }
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_presence_of(:transmitted_at) }
      it { is_expected.to validate_presence_of(:direction) }
      it { is_expected.to validate_presence_of(:format) }
      it { is_expected.to have_db_index(:patient_id) }
      it { is_expected.to have_db_index(:dialysis_unit_id) }
      it { is_expected.to have_db_index(:direction) }
      it { is_expected.to have_db_index(:format) }
      it { is_expected.to have_db_index(:transmitted_at) }
    end
  end
end
