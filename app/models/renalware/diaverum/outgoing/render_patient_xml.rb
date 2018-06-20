# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Outgoing
      # Render a patient to Diaverum format XML using the Rails 5 'Render anywhere' approach
      # in this instance using PatientsController and its show template.
      # Note this does not call PatientsController#show directly but just renders the show template
      # in the same way that calling PatientsController#show does.
      class RenderPatientXml
        pattr_initialize :patient

        def call
          Diaverum::PatientsController.render(
            :show,
            locals: {
              patient: Diaverum::PatientPresenter.new(patient)
            }
          )
        end
      end
    end
  end
end
