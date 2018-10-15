# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      class SavePatientSession
        include Diaverum::Logging
        pattr_initialize :patient, :treatment_node, :transmission_log

        # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
        # rubocop:disable Metrics/PerceivedComplexity
        def call
          existing_session = Renalware::HD::Session
            .select(:id, :external_id, :created_at)
            .find_by(external_id: treatment_node.TreatmentId)

          if existing_session.present?
            transmission_log.update!(
              result: "previously imported #{I18n.l(existing_session.created_at)}",
              session: existing_session,
              external_session_id: treatment_node.TreatmentId
            )
            return
          end

          # return if Renalware::HD::Session.exists?(external_id: treatment_node.TreatmentId)

          transmission_log.update!(
            payload: treatment_node.to_xml,
            external_session_id: treatment_node.TreatmentId
          )

          begin
            session = SessionBuilder.call(
              patient: patient,
              treatment_node: treatment_node,
              user: user
            )
          rescue StandardError => exception
            transmission_log.update!(
              error_messages: ["#{exception.cause} #{exception.message}"],
              result: "error"
            )
            return
          end

          begin
            # For now skip saving in production
            if Diaverum.config.diaverum_incoming_skip_session_save || Rails.env.production?
              session.validate!
              transmission_log.update!(result: "ok")
            else
              session.save!
              transmission_log.update!(result: "ok", session: session)
            end
          rescue ActiveRecord::RecordInvalid
            error_messages = [
              session.errors&.full_messages,
              session.document.error_messages
            ].flatten.compact.reject{ |msg| msg == "is invalid" }

            transmission_log.update!(error_messages: error_messages, result: "error")

            raise Errors::SessionInvalidError, error_messages
          end
        end
        # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
        # rubocop:enable Metrics/PerceivedComplexity

        private

        # Returns an existing session or a new one if not found
        def existing_session(external_id)
          patient.hd_sessions.closed.find_by(external_id: external_id)
        end

        def user
          @user ||= Renalware::SystemUser.find
        end
      end
    end
  end
end
