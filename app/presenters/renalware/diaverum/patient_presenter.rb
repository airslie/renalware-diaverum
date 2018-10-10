# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    class PatientPresenter < SimpleDelegator
      def height_in_cm
        return if last_clinic_visit.blank? || last_clinic_visit.height.blank?

        last_clinic_visit.height.to_f * 100.0
      end

      private

      def clinics_patient
        ActiveType.cast(__getobj__, ::Renalware::Clinics::Patient)
      end

      def last_clinic_visit
        @last_clinic_visit ||= clinics_patient.clinic_visits.order(created_at: :desc).first
      end
    end
  end
end
