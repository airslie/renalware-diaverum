# frozen_string_literal: true

puts "Diaverum::HDTypeMap"
Renalware::Diaverum::HDTypeMap.find_or_create_by!(diaverum_type_id: "HFLUX", hd_type: "HD")
Renalware::Diaverum::HDTypeMap.find_or_create_by!(diaverum_type_id: "HDFPO", hd_type: "HDF")
Renalware::Diaverum::HDTypeMap.find_or_create_by!(diaverum_type_id: "HDFPR", hd_type: "HDF")
