# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      # Save all Sessions
      class SavePatientSessions
        pattr_initialize :patient_node, :transmission_log

        # helperer for new(...).call()
        def self.call(path_to_xml, transmission_log)
          @transmission_log = transmission_log
          transmission_log.update!(payload: File.read(path_to_xml))
          doc = File.open(Pathname(path_to_xml)) { |f| Nokogiri::XML(f) }
          File.write(Rails.root.join("bla2.xml"), doc.to_xml)
          new(Incoming::PatientXmlDocument.new(doc), transmission_log).call
        end

        def call
          patient = find_patient
          transmission_log.update!(patient: patient)

          patient_node.each_session do |session_node|
            child_log = create_child_transmission_log
            begin
              SavePatientSession.new(patient, session_node, child_log).call
            rescue Errors::SessionInvalidError => e
              # Do nothing as already logged in SavePatientSession in child_log.
              # Move onto try importing the next session
            end
          end
        end

        private

        def create_child_transmission_log
          HD::TransmissionLog.create!(
            direction: :in,
            format: :xml,
            parent_id: transmission_log.id,
            patient_id: transmission_log.patient_id
          )
        end

        # Raises an exception if the patient is not found
        def find_patient
          Renalware::HD::Patient.find_by!(local_patient_id: patient_node.local_patient_id)
        end
      end
    end
  end
end
