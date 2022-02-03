# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      #
      # A subscriber to renalware-core pathology messages.
      #
      class PathologyListener
        # This method intercepts the event raised when an HL7 message has been
        # successfully processed. If the HL7 messages concerns a patient having dialysis at
        # a Diaverum unit, we forward the HL7 message on to Diaverum using a background job
        def self.oru_message_processed(args)
          new.oru_message_processed(args)
        end

        def oru_message_processed(args)
          feed_message = args[:feed_message]
          local_patient_id = feed_message.patient_identifier
          return if local_patient_id.blank?

          patient = find_diaverum_patient(local_patient_id)
          return if patient.blank?

          ForwardHl7Job.perform_later(
            transmission: transmission_log_for(patient, feed_message)
          )
        end

        private

        def find_diaverum_patient(local_patient_id)
          PatientQuery.new(local_patient_id: local_patient_id).call
        end

        def transmission_log_for(patient, feed_message)
          Renalware::HD::TransmissionLog.create(
            patient: patient,
            payload: feed_message.body,
            format: :hl7,
            direction: :out
          )
        end
      end
    end
  end
end
