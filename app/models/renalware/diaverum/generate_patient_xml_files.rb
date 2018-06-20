module Renalware
  module Diaverum
    class GeneratePatientXmlFiles
      attr_reader :file_datestamp, :hospital_unit_code, :destination_path

      def self.call(*args)
        new(*args).call
      end

      def initialize(hospital_unit_code:, destination_path:)
        raise(ArgumentError, "Blank destination_path") if destination_path.blank?
        raise(ArgumentError, "Blank hospital_unit_code") if hospital_unit_code.blank?

        @hospital_unit_code = hospital_unit_code
        @destination_path = Pathname(destination_path)
        @file_datestamp = Time.zone.today
        FileUtils.mkdir_p(@destination_path) unless Rails.env.production?
      end

      def call
        patients = PatientsQuery.new(hospital_unit).call
        patients.each { |patient| render_patient_to_xml_file(patient) }
      end

      private

      def render_patient_to_xml_file(patient)
        File.write(
          filename_for(patient),
          Diaverum::RenderPatientXml.new(patient).call
        )
      end

      def hospital_unit
        @hospital_unit ||= Hospitals::Unit.find_by!(unit_code: hospital_unit_code)
      end

      def filename_for(patient)
        destination_path.join("#{file_datestamp.strftime("%Y%m%d")}-#{patient.secure_id}.xml")
      end
    end
  end
end
