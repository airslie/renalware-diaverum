# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      class SavePatientSession
        include Diaverum::Logging
        pattr_initialize :patient, :treatment_node, :log

        def call
          return if session_exists_already?

          log_payload
          session = build_session
          save_session(session)
        rescue ActiveRecord::RecordNotFound,
               ActiveRecord::RecordInvalid,
               Errors::SessionError => exception
          error_messages = errors_in(session, exception)
          raise Errors::SessionInvalidError, error_messages
        end

        private

        def session_exists_already?
          if existing_session.present?
            log_warning_that_session_already_exists
            true
          else
            false
          end
        end

        # Returns an existing session or a new one if not found
        def existing_session
          @existing_session ||= begin
            Renalware::HD::Session
              .select(:id, :external_id, :created_at)
              .find_by(external_id: treatment_node.TreatmentId)
          end
        end

        def build_session
          SessionBuilder.call(
            patient: patient,
            treatment_node: treatment_node,
            user: user
          )
        end

        def save_session(session)
          # For now skip saving in production
          if Diaverum.config.diaverum_incoming_skip_session_save || Rails.env.production?
            session.validate!
            log.update!(result: "ok")
          else
            session.save!
            log.update!(result: "ok", session: session)
          end
        end

        def errors_in(session, exception)
          error_messages = if session.present?
                             [
                               session.errors&.full_messages,
                               session.document.error_messages
                             ].flatten.compact.reject{ |msg| msg == "is invalid" }
                           else
                             ["#{exception.cause} #{exception.message}"]
                           end
          log.update!(error_messages: error_messages, result: "error")
          error_messages
        end

        def log_payload
          log.update!(
            payload: treatment_node.to_xml,
            external_session_id: treatment_node.TreatmentId
          )
        end

        def log_warning_that_session_already_exists
          log.update!(
            result: "previously imported #{I18n.l(existing_session.created_at)}",
            session: existing_session,
            external_session_id: treatment_node.TreatmentId
          )
        end

        def user
          @user ||= Renalware::SystemUser.find
        end
      end
    end
  end
end
