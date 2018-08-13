# frozen_string_literal: true

require_dependency "renalware/diaverum"

Renalware::Diaverum.configure do |_config|
  Renalware::Diaverum::Paths.setup unless Rails.env.test?
end
