# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      # Save all Sessions in a particular patient XML file.
      class SaveSessions
        pattr_initialize [:path_to_xml!, :log!]

        def self.call(**args)
          new(**args).call
        end

        def call
          patient_node.each_treatment do |treatment_node|
            begin
              SaveSession.new(
                patient: patient,
                treatment_node: treatment_node,
                parent_log: log,
                patient_node: patient_node
              ).call
            rescue Errors::SessionInvalidError => e
              raise(e) if Rails.env.development?
              # Do nothing as already logged in SaveSession in child_log.
              # Move on to try importing the next session
            end
          end
        end

        private

        def patient_node
          @patient_node ||= begin
            xml_document = File.open(Pathname(path_to_xml)) { |f| Nokogiri::XML(f) }
            Nodes::Patients.new(xml_document.root).one_and_only_patient_node
          end
        end

        def patient
          @patient = case_insensitive_find_patient
        end

        def case_insensitive_find_patient
          patient = Renalware::HD::Patient.where(
            "upper(local_patient_id) = ? or nhs_number = ?",
            patient_node.local_patient_id.upcase,
            patient_node.local_patient_id
          ).first!
          log.update!(patient: patient)
          patient
        end
      end
    end
  end
end
