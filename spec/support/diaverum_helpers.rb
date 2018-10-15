# frozen_string_literal: true

module Renalware
  module Diaverum
    module DiaverumHelpers
      def using_a_tmp_diaverum_path
        Dir.mktmpdir do |dir|
          ENV["DIAVERUM_FOLDER"] = dir
          Renalware::Diaverum::Paths.setup
          yield
        end
      end

      def create_patient_xml_document(options: {})
        erb_template = options.fetch(
          :erb_template,
          Engine.root.join("spec", "fixtures", "files", "diaverum_example.xml.erb")
        )
        system_user = create(:user, username: SystemUser.username)
        access_map = AccessMap.create!(
          diaverum_location_id: "LEJ",
          diaverum_type_id: 7,
          access_type: create(:access_type),
          side: :left
        )
        hospital_unit = create(:hospital_unit)
        dialysate = create(:hd_dialysate)
        provider = HD::Provider.create!(name: "Diaverum")
        dialysis_unit = HD::ProviderUnit.create!(
          hospital_unit: hospital_unit,
          hd_provider: provider,
          providers_reference: "123"
        )
        xml_filepath = Engine.root.join("spec", "fixtures", "files", "diaverum_example.xml.erb")
        xml_string = ERB.new(xml_filepath.read).result(binding)
        Nokogiri::XML(xml_string)
      end

      def create_access_map
        AccessMap.create!(
          diaverum_location_id: "LEJ",
          diaverum_type_id: 7,
          access_type: access_type,
          side: :left
        )
      end

      def create_hd_type_map
        HDTypeMap.create!(diaverum_type_id: "HFLUX", hd_type: :hd)
      end
    end
  end
end
