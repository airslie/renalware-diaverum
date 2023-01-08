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
        # a Diaverum unit, we forward the HL7 message on to Diaverum using a background job.
        # In order to lookup the patient (so we can tell if they are a diaverum patient or not)
        # we look at feed_messages.patient_identifier - the nhs_number if there was one in the HL7 -
        # or feed_messages.patient_identifiers which is a JSONB array of hospital numbers pulled
        # form the hospital_ids bit of the HL7 PID segment. Currently we only support just mapping
        # the first value in the JSONB to patients.local_patient_id, a simplistic case that works
        # at KCH.
        def self.oru_message_processed(args)
          new.oru_message_processed(args)
        end

        def oru_message_processed(args)
          feed_message = args[:feed_message]
          nhs_number = feed_message.patient_identifier
          hosp_no = (feed_message.patient_identifiers || {}).values.first

          patient = PatientQuery.new(nhs_number: nhs_number, hosp_no: hosp_no).call
          return if patient.blank?

          ForwardHL7Job.perform_later(transmission: transmission_log_for(patient, feed_message))
        end

        private

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
