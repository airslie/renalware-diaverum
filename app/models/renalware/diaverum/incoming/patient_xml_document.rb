# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      class DiaverumXMLParsingError < StandardError; end

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
            raise(DiaverumXMLParsingError, "HospitalNumber not present") if id.blank?
            id
          end
        end

        def patient_node
          @patient_node ||= node.root.xpath("Patient").first
        end

        def nhs_number
          @nhs_number ||= begin
            num = patient_node.xpath("ExternalPatientId")&.text
            raise(DiaverumXMLParsingError, "ExternalPatientId (NHS Number) not present") if num.blank?
            num
          end
        end

        def each_session
          patient_node.xpath("Treatments/Treatment").each do |node|
            yield SessionXmlDocument.new(node) if block_given?
          end
        end

        private

        def validate
          if node.root.name != "Patients"
            raise(DiaverumXMLParsingError, "Unexpected root element #{node.root.name}")
          end
          if node.xpath("Patients/Patient").length != 1
            raise(DiaverumXMLParsingError, "File does not contain exactly one Patient element!")
          end
        end
      end
    end
  end
end
