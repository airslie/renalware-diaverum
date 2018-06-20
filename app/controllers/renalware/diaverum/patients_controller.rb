# frozen_string_literal: true

require_dependency "renalware"

module Renalware
  module Diaverum
    class PatientsController < Renalware::BaseController
      helper Renalware::Diaverum::Engine.routes.url_helpers

      respond_to :xml

      def show
        hospital_unit # ??
        respond_to do |format|
          format.xml do
            patient = unit_patients.find_by(secure_id: params[:id])
            authorize patient
            render locals: { patient: patient }
          end
        end
      end

      def index
        hospital_unit # ??

        respond_to do |format|
          format.xml do
            patients = unit_patients.all
            authorize patients
            render locals: { hospital_unit: hospital_unit, patients: patients }
          end
        end
      end

      private

      def hospital_unit
        Hospitals::Unit.find(params[:unit_id])
      end

      def unit_patients
        PatientsQuery.call(hospital_unit)
      end
    end
  end
end
