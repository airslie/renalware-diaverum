# frozen_string_literal: true

puts "HD::Provider"

provider = Renalware::HD::Provider.find_or_create_by!(name: "Diaverum")

puts "HD::ProviderUnit"

Renalware::HD::ProviderUnit.find_or_create_by!(
  hospital_unit: Renalware::Hospitals::Unit.first,
  hd_provider: provider,
  providers_reference: "1831"
)
