# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    class RenderPatientXml
      pattr_initialize :patient

      def call
        Diaverum::PatientsController.render(:show, locals: { patient: patient })
      end
    end
  end
end
