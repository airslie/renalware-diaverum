# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      # Save all Sessions
      class SavePatientSessions
        pattr_initialize :patient_node

        # helperer for new(...).call()
        def self.call(path_to_xml)
          doc = Nokogiri::XML(Pathname(path_to_xml))
          new(Diaverum::PatientXmlDocument.new(doc)).call
        end

        def call
          patient_node.each_session do |session_node|
            SavePatientSession.new(patient, session_node).call
          end
        end

        private

        # Raises an exception if the patient is not found
        def patient
          @patient ||= begin
            Renalware::HD::Patient.find_by!(local_patient_id: patient_node.local_patient_id)
          end
        end
      end
    end
  end
end
