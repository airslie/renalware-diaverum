# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      # Save all Sessions
      class SavePatientSessions
        pattr_initialize :patient_node, :log

        # helper for new(...).call()
        def self.call(path_to_xml, log)
          @log = log
          log.update!(payload: File.read(path_to_xml))
          doc = File.open(Pathname(path_to_xml)) { |f| Nokogiri::XML(f) }
          patient_document = Incoming::PatientXmlDocument.new(doc)
          new(doc, log).call
        end

        def call
          patient = case_insensitive_find_patient
          log.update!(patient: patient)

          patient_node.each_session do |session_node|
            child_log = create_child_log
            begin
              SavePatientSession.new(patient, session_node, child_log).call
            rescue Errors::SessionInvalidError
              # Do nothing as already logged in SavePatientSession in child_log.
              # Move on to try importing the next session
            end
          end
        end

        private

        def create_child_log
          HD::TransmissionLog.create!(
            direction: :in,
            format: :xml,
            parent_id: log.id,
            patient_id: log.patient_id
          )
        end

        def case_insensitive_find_patient
          Renalware::HD::Patient.where(
            "upper(local_patient_id) = ?",
            patient_node.local_patient_id.upcase
          ).first!
        end
      end
    end
  end
end
