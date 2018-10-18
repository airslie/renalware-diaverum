# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      # Given a Diaverum HD Treatment XML node with a StartTime (indicating its not a DNA session)
      # and a patient, build a new, unsaved HD::Session object by mapping diaverum attributes to
      # Renalware ones.
      class ClosedSessionBuilder < SessionBuilder
        def call
          assign_top_level_attributes
          build_info
          build_dialysis
          build_observations_before
          build_observations_after
          build_hdf
          session
        end

        private

        def session
          @session ||= Renalware::HD::Session::Closed.new
        end

        def assign_top_level_attributes
          session.assign_attributes(
            patient: patient,
            hospital_unit: hospital_unit,
            performed_on: treatment_node.Date,
            start_time: treatment_node.StartTime,
            end_time: treatment_node.EndTime,
            notes: treatment_node.Notes,
            created_by: user,
            updated_by: user,
            signed_on_by: user,
            signed_off_by: user,
            signed_off_at: Time.zone.parse("#{treatment_node.Date} #{treatment_node.EndTime}"),
            dry_weight: most_recent_dry_weight,
            dialysate: dialysate,
            external_id: treatment_node.TreatmentId
          )
        end

        def build_info
          info = session.document.info
          info.hd_type = HDTypeMap.for(diaverum_type_id: treatment_node.TypeId)
          info.machine_no = treatment_node.MachineIdentifier
          build_access(info)
        end

        def build_access(info)
          info.access_confirmed = true
          info.access_type = access_type.access_type&.name
          info.access_type_abbreviation = access_type.access_type&.abbreviation
          info.access_side = access_type.side
        end

        def build_dialysis
          dialysis = session.document.dialysis
          dialysis.arterial_pressure = treatment_node.ArterialPressure
          dialysis.venous_pressure = treatment_node.VenousPressure
          dialysis.fluid_removed = treatment_node.RemovedVolume
          dialysis.blood_flow = treatment_node.Bloodflow
          dialysis.flow_rate = treatment_node.DialysateFlow
          dialysis.machine_urr = nil
          dialysis.machine_ktv = treatment_node.KTV
          dialysis.litres_processed = treatment_node.TreatedBloodVolume
        end

        def build_observations_before
          pre = session.document.observations_before
          pre.pulse = treatment_node.PulsePre
          pre.blood_pressure.systolic = treatment_node.SystolicBloodPressurePre
          pre.blood_pressure.diastolic = treatment_node.DiastolicBloodPressurePre
          pre.weight_measured = treatment_node.WeightPre.present? ? :yes : :no
          pre.weight = treatment_node.WeightPre
          pre.temperature_measured = treatment_node.TemperaturePre.present? ? :yes : :no
          pre.temperature = treatment_node.TemperaturePre
        end

        def build_observations_after
          post = session.document.observations_after
          post.pulse = treatment_node.PulsePost
          post.blood_pressure.systolic = treatment_node.SystolicBloodPressurePost
          post.blood_pressure.diastolic = treatment_node.DiastolicBloodPressurePost
          post.weight_measured = treatment_node.WeightPost.present? ? :yes : :no
          post.weight = treatment_node.WeightPost
          post.temperature_measured = treatment_node.TemperaturePost.present? ? :yes : :no
          post.temperature = treatment_node.TemperaturePost
        end

        def build_hdf
          hdf = session.document.hdf
          hdf.subs_volume = treatment_node.InfusionVolume
        end
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize
