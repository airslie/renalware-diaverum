# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      # Wraps an incoming Patient XML node
      class PatientXmlDocument
        attr_reader :node

        def initialize(node)
          @node = node
          validate
        end

        def local_patient_id
          @local_patient_id ||= begin
            id = patient_node.xpath("HospitalNumber")&.text
            raise(Errors::DiaverumXMLParsingError, "HospitalNumber not present") if id.blank?

            id
          end
        end

        def patient_node
          @patient_node ||= node.root.xpath("/Patients/Patient").first
        end

        def nhs_number
          @nhs_number ||= begin
            num = patient_node.xpath("ExternalPatientId")&.text
            if num.blank?
              raise(Errors::DiaverumXMLParsingError, "ExternalPatientId (NHS Number) not present")
            end

            num
          end
        end

        def each_session
          session_nodes.each do |node|
            yield SessionXmlDocument.new(node) if block_given?
          end
        end

        def session_nodes
          @session_nodes ||= begin
            patient_node.xpath("/Patients/Patient/Treatments/Treatment").map do |node|
              SessionXmlDocument.new(node)
            end
          end
        end

        private

        def validate
          if node.root.name != "Patients"
            raise(Errors::DiaverumXMLParsingError, "Unexpected root element #{node.root.name}")
          end
          if node.xpath("Patients/Patient").length != 1
            raise(Errors::DiaverumXMLParsingError, "File doesn't contain only one Patient element!")
          end
        end
      end
    end
  end
end
