# frozen_string_literal: true

puts "Diaverum::AccessMap"

Renalware::Diaverum::AccessMap.find_or_create_by(
  diaverum_location_id: "LUA",
  diaverum_type_id: 1,
  side: "left",
  access_type_id: 1
)

Renalware::Diaverum::AccessMap.find_or_create_by(
  diaverum_location_id: "LFA",
  diaverum_type_id: 1,
  side: "left",
  access_type_id: 2
)
