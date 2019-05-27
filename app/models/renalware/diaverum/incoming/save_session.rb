# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      # rubocop:disable Metrics/ClassLength
      class SaveSession
        include Diaverum::Logging
        pattr_initialize [:patient!, :treatment_node!, :parent_log!, :patient_node!]

        def call
          if session_exists_already?
            handle_existing_session
          else
            create_new_session
          end
        end

        private

        def handle_existing_session
          marked_existing_session_as_deleted if treatment_node.requires_deletion?
          log_warning_that_session_already_exists
          flag_journal_entries_for_this_session_as_assigned
        end

        def create_new_session
          return if treatment_start_date_before_go_live_date?
          return if treatment_node.requires_deletion?

          log_payload
          session = build_session
          save_session(session)
        rescue ActiveRecord::RecordNotFound,
               ActiveRecord::RecordInvalid,
               Errors::SessionError => e
          error_messages = errors_in(session, e)
          raise Errors::SessionInvalidError, error_messages
        end

        def flag_journal_entries_for_this_session_as_assigned
          patient_node.journal_entries_on(treatment_node.Date).each do |entry|
            entry.included_in_session_notes = true
          end
        end

        def log
          @log ||= create_child_log
        end

        # Associate the child log with the parent through parent_id but also
        # propogate the uuid down to child logs in order to tie al log entries together
        # for this (rake) 'run'
        def create_child_log
          HD::TransmissionLog.create!(
            direction: :in,
            format: :xml,
            parent_id: parent_log.id,
            patient_id: parent_log.patient_id,
            uuid: parent_log.uuid
          )
        end

        def session_exists_already?
          existing_session.present?
        end

        def marked_existing_session_as_deleted
          existing_session.delete # skip callbacks
        end

        def treatment_start_date_before_go_live_date?
          ignore = treatment_node.Date < Diaverum.config.diaverum_go_live_date
          log_warning_that_xml_predates_go_live_date if ignore
          ignore
        end

        def existing_session
          @existing_session ||= begin
            Renalware::HD::Session
              .select(:id, :external_id, :created_at)
              .find_by(external_id: treatment_node.TreatmentId)
          end
        end

        def build_session
          args = {
            treatment_node: treatment_node,
            patient: patient,
            user: user,
            patient_node: patient_node
          }
          builder = SessionBuilders::Factory.builder_for(**args)
          builder.call
        end

        def save_session(session)
          if Diaverum.config.diaverum_incoming_skip_session_save
            session.validate!
            log.update!(result: "would be imported")
          else
            session.save!
            HD::UpdateRollingPatientStatisticsJob.perform_later(patient)
            log.update!(result: "imported", session: session)
          end
        end

        def errors_in(session, exception)
          error_messages = if session.present?
                             [
                               session.errors&.full_messages,
                               session.document.error_messages
                             ].flatten.compact.reject { |msg| msg == "is invalid" }
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
          return if log.blank?

          log.update!(
            result: "previously imported #{I18n.l(existing_session.created_at)}",
            session: existing_session,
            external_session_id: treatment_node.TreatmentId
          )
        end

        def log_warning_that_xml_predates_go_live_date
          return if log.blank?

          msg = "Ignoring as #{treatment_node.Date} pre-dates go live date "\
                "#{Diaverum.config.diaverum_go_live_date}"
          log.update!(result: msg, external_session_id: treatment_node.TreatmentId)
        end

        def user
          @user ||= Renalware::SystemUser.find
        end
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
