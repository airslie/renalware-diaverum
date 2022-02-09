# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      class FeedMessagesQuery
        def self.call(**args)
          new.call(**args)
        end

        def call(from_date:, to_date:)
          from_date = DateTime.parse(from_date).beginning_of_day
          to_date = DateTime.parse(to_date).end_of_day
          patients = PatientQuery.diaverum_patients
          Renalware::Feeds::Message
            .where(event_code: "ORU^R01")
            .where("created_at >= ? and created_at < ?", from_date, to_date)
            .where(
              "(patient_identifier in (?) or patient_identifiers ->> 'PAS Number' in (?))",
              patients.pluck(:nhs_number),
              patients.pluck(:local_patient_id)
            )
        end
      end
    end
  end
end
