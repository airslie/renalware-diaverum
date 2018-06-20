# frozen_string_literal: true

require_dependency "renalware"

module Renalware
  module Diaverum
    # The purpose of this controller is twofold:
    #  1. to provide a preview of the XML that would be exported to Diaverum for a particular
    #     hospital unit and its HD patients
    #  2. the rake task that exports the XML uses this controller and its views in Rails 5
    #     'render anywhere' style from RenderPatientXml (note it does not invoke the show method
    #     directly)
    class PatientsController < Renalware::BaseController
      helper Renalware::Diaverum::Engine.routes.url_helpers

      respond_to :xml

      # Renders the XML that will be exported for a particular patient.
      def show
        respond_to do |format|
          format.xml do
            patient = unit_patients.find_by(secure_id: params[:id])
            authorize patient
            render locals: { patient: patient }
          end
        end
      end

      # Provides a helper index view to see a list of patients that would be exported.
      # We don't send Diaverum the XML created here - its just a list of patients for our
      # benefit, each with a link to its respective #show url where the real XML can be previewed.
      def index
        respond_to do |format|
          format.xml do
            patients = unit_patients.all
            authorize patients
            render locals: { hospital_unit: hospital_unit, patients: patients }
          end
        end
      end

      private

      def unit_patients
        PatientsQuery.call(hospital_unit)
      end

      def hospital_unit
        @hospital_unit ||= Hospitals::Unit.find(params[:unit_id])
      end
    end
  end
end
