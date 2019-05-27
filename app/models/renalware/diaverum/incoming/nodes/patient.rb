# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      module Nodes
        # Wraps an incoming Patient XML node
        class Patient < Node
          def local_patient_id
            @local_patient_id ||= begin
              id = xpath("HospitalNumber")&.text
              raise(Errors::DiaverumXMLParsingError, "HospitalNumber not present") if id.blank?

              id
            end
          end

          def patient_node
            @patient_node ||= node.root.xpath("/Patients/Patient").first
          end

          def nhs_number
            @nhs_number ||= begin
              num = xpath("ExternalPatientId")&.text
              if num.blank?
                raise(Errors::DiaverumXMLParsingError, "ExternalPatientId (NHS Number) not present")
              end

              num
            end
          end

          def each_treatment
            treatment_nodes.each do |node|
              yield Nodes::Treatment.new(node) if block_given?
            end
          end

          def treatment_nodes
            @treatment_nodes ||= begin
              xpath("/Patients/Patient/Treatments/Treatment").map do |node|
                Nodes::Treatment.new(node)
              end
            end
          end

          def current_dialysis_prescription
            @current_dialysis_prescription ||= begin
              path = "/Patients/Patient/DialysisPrescriptions/DialysisPrescription"
              prescriptions = xpath(path).map { |node| Nodes::Prescription.new(node) }
              prescriptions.detect(&:active?)
            end
          end

          def journal_entries
            @journal_entries ||= begin
              xpath("/Patients/Patient/JournalEntries/JournalEntry").map do |node|
                Nodes::JournalEntry.new(node)
              end
            end
          end

          def journal_entries_on(date)
            journal_entries.select do |entry|
              Date.parse(entry.Date) == date
            end
          end
        end
      end
    end
  end
end
