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

          return if Renalware::HD::Session.exists?(external_id: treatment_node.TreatmentId)

          transmission_log.update!(
            payload: treatment_node.to_xml,
            external_session_id: treatment_node.TreatmentId
          )

          begin
            session = SessionBuilder.new(
              patient: patient,
              treatment_node: treatment_node,
              user: user
            ).call

            # session = Renalware::HD::Session::Closed.new(
            #   patient: patient,
            #   hospital_unit: hospital_unit,
            #   performed_on: treatment_node.Date,
            #   start_time: treatment_node.StartTime,
            #   end_time: treatment_node.EndTime,
            #   notes: treatment_node.Notes,
            #   created_by: user,
            #   updated_by: user,
            #   signed_on_by: user,
            #   signed_off_by: user,
            #   signed_off_at: Time.zone.parse("#{treatment_node.Date} #{treatment_node.EndTime}"),
            #   dry_weight: most_recent_dry_weight,
            #   dialysate: dialysate,
            #   external_id: treatment_node.TreatmentId
            # )

            # info = session.document.info
            # info.hd_type = :hd
            # info.machine_no = treatment_node.MachineIdentifier
            # build_access(info)

            # dialysis = session.document.dialysis
            # dialysis.arterial_pressure = treatment_node.ArterialPressure
            # dialysis.venous_pressure = treatment_node.VenousPressure
            # dialysis.fluid_removed = treatment_node.RemovedVolume
            # dialysis.blood_flow = treatment_node.Bloodflow
            # dialysis.flow_rate = treatment_node.DialysateFlow
            # dialysis.machine_urr = nil
            # dialysis.machine_ktv = treatment_node.KTV
            # dialysis.litres_processed = treatment_node.TreatedBloodVolume

            # pre = session.document.observations_before
            # pre.pulse = treatment_node.PulsePre
            # pre.blood_pressure.systolic = treatment_node.SystolicBloodPressurePre
            # pre.blood_pressure.diastolic = treatment_node.DiastolicBloodPressurePre
            # pre.weight_measured = treatment_node.WeightPre.present? ? :yes : :no
            # pre.weight = treatment_node.WeightPre
            # pre.temperature_measured = treatment_node.TemperaturePre.present? ? :yes : :no
            # pre.temperature = treatment_node.TemperaturePre

            # post = session.document.observations_after
            # post.pulse = treatment_node.PulsePost
            # post.blood_pressure.systolic = treatment_node.SystolicBloodPressurePost
            # post.blood_pressure.diastolic = treatment_node.DiastolicBloodPressurePost
            # post.weight_measured = treatment_node.WeightPost.present? ? :yes : :no
            # post.weight = treatment_node.WeightPost
            # post.temperature_measured = treatment_node.TemperaturePost.present? ? :yes : :no
            # post.temperature = treatment_node.TemperaturePost

            # hdf = session.document.hdf
            # hdf.subs_volume = treatment_node.InfusionVolume
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

        # def build_access(info)
        #   info.access_confirmed = true
        #   info.access_type = access_type.access_type&.name
        #   info.access_type_abbreviation = access_type.access_type&.abbreviation
        #   info.access_side = access_type.side
        # end

        # Returns an existing session or a new one if not found
        def existing_session(external_id)
          patient.hd_sessions.closed.find_by(external_id: external_id)
        end

        # def hospital_unit
        #   dialysis_unit.hospital_unit
        # end

        # def dialysis_unit
        #   HD::ProviderUnit.find_by!(providers_reference: treatment_node.ClinicId)
        # end

        # def dialysate
        #   raise Errors::DialysateMissingError if treatment_node.Dialysate.blank?
        #   Renalware::HD::Dialysate.find_by!(name: treatment_node.Dialysate)
        # rescue ActiveRecord::RecordNotFound
        #   raise Errors::DialysateNotFoundError, treatment_node.Dialysate
        # end

        # def access_type
        #   @access_type ||= begin
        #     args = {
        #       diaverum_location: treatment_node.AccessLocationId,
        #       diaverum_type: treatment_node.AccessTypeId
        #     }
        #     AccessMap.for(args)
        #   end
        # rescue ActiveRecord::RecordNotFound
        #   raise AccesMapError, args
        # end

        def user
          @user ||= Renalware::SystemUser.find
        end

        # def most_recent_dry_weight
        #   Renalware::Clinical::DryWeight
        #     .for_patient(patient)
        #     .order(assessed_on: :desc)
        #     .first
        # end
      end
    end
  end
end
