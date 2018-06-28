# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      class SavePatientSession
        include Diaverum::Logging
        pattr_initialize :patient, :session_node

        def call
          session = existing_session(session_node.TreatmentId)

          session = Renalware::HD::Session::Closed.new(
            patient: patient,
            hospital_unit: hospital_unit,
            performed_on: session_node.Date,
            start_time: session_node.StartTime,
            end_time: session_node.EndTime,
            notes: session_node.Notes,
            created_by: user,
            updated_by: user,
            signed_on_by: user,
            signed_off_by: user,
            signed_off_at: Time.zone.parse("#{session_node.Date} #{session_node.EndTime}"),
            dry_weight: most_recent_dry_weight,
            dialysate: dialysate
          )

          info = session.document.info
          info.hd_type = :hd
          info.machine_no = session_node.MachineIdentifier
          build_access(info)

          dialysis = session.document.dialysis
          dialysis.arterial_pressure = session_node.ArterialPressure
          dialysis.venous_pressure = session_node.VenousPressure
          dialysis.fluid_removed = session_node.RemovedVolume
          dialysis.blood_flow = session_node.Bloodflow
          dialysis.flow_rate = session_node.DialysateFlow
          dialysis.machine_urr = nil
          dialysis.machine_ktv = session_node.KTV
          dialysis.litres_processed = session_node.InfusionVolume

          pre = session.document.observations_before
          pre.pulse = session_node.PulsePre
          pre.blood_pressure.systolic = session_node.SystolicBloodPressurePre
          pre.blood_pressure.diastolic = session_node.DiastolicBloodPressurePre
          pre.weight_measured = :yes
          pre.weight = session_node.WeightPre
          pre.temperature_measured = session_node.TemperaturePre.present? ? :yes : :no
          pre.temperature = session_node.TemperaturePre

          post = session.document.observations_after
          post.pulse = session_node.PulsePost
          post.blood_pressure.systolic = session_node.SystolicBloodPressurePost
          post.blood_pressure.diastolic = session_node.DiastolicBloodPressurePost
          post.weight_measured = :yes
          post.weight = session_node.WeightPost
          post.temperature_measured = session_node.TemperaturePost..present? ? :yes : :no
          post.temperature = session_node.TemperaturePost

          unless session.valid?
            p [
              session.errors.full_messages,
              session.document.error_messages,
            ].flatten.compact
          end

          session.save!
        end

        private

        def build_access(info)
          info.access_confirmed = true
          info.access_type = access_type
          info.access_type_abbreviation = "AVG"
          info.access_side = :left
        end

        # Returns an existing session or a new one if not found
        def existing_session(external_id)
          patient.hd_sessions.closed.find_by(external_id: external_id)
        end

        def hospital_unit
          dialysis_unit.hospital_unit
        end

        def dialysis_unit
          DialysisUnit.find_by!(diaverum_clinic_id: session_node.ClinicId)
        end

        def dialysate
          Renalware::HD::Dialysate.find_by!(name: session_node.Dialysate)
        end

        def access_type
          args = {
            diaverum_location: session_node.AccessLocationId,
            diaverum_type: session_node.AccessTypeId
          }
          AccessMap.for(args).access_type
          rescue ActiveRecord::RecordNotFound => e
            raise AccesMapError, args
        end

        def user
          @user ||= Renalware::SystemUser.find
        end

        def most_recent_dry_weight
          Renalware::Clinical::DryWeight
            .for_patient(patient)
            .order(assessed_on: :desc)
            .first
        end
      end
    end
  end
end
