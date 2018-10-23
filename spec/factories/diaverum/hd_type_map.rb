# frozen_string_literal: true

FactoryBot.define do
  factory :hd_type_map, class: "Renalware::Diaverum::HDTypeMap" do
    trait :hd do
      diaverum_type_id { "HFLUX" }
      hd_type { :hd }
    end

    trait :hdf_pre do
      diaverum_type_id { "HDFPR" }
      hd_type { :hdf_pre }
    end

    trait :hdf_post do
      diaverum_type_id { "HDFPO" }
      hd_type { :hdf_post }
    end
  end
end
