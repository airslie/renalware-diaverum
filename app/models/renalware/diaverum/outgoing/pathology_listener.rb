# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      #
      # A subscriber to renalware-core patholoy messages.
      #
      class PathologyListener
        # This method intercepts the event raised when an HL7 message has been
        # successfully processed. If the HL7 messages concerns a patient having dialysis at
        # a Diaverum unit, we forward the HL7 message on to Diaverum using a background job
        # (which lets us queue up jobs if for example the commication mechanism is temporarily down)
        def message_processed(feed_message:, **)
          local_patient_id = feed_message.patient_identifier
          return if local_patient_id.blank?
          patient = find_diaverum_patient(local_patient_id)
          return if patient.blank?

          # TODO
          ForwardHl7Job.perform_now(
            transmission: transmission_for(patient, feed_message)
          )
        end

        private

        def find_diaverum_patient(local_patient_id)
          PatientQuery.new(local_patient_id: local_patient_id).call
        end

        def transmission_for(patient, feed_message)
          Transmission.create!(
            patient: patient,
            dialysis_unit: nil, # TODO: lookup
            direction: :out,
            format: :hl7,
            payload: feed_message.body
          )
        end
      end
    end
  end
end
