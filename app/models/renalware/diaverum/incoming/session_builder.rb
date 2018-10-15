# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize, Metrics/ClassLength, Metrics/MethodLength
require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      # Given a Diaverum HD Treatment XML node and a patient, build a new, unsaved HD::Session
      # object by mapping diaverum attributes to Renalware ones.
      class SessionBuilder
        attr_reader :patient, :treatment_node, :user, :session

        def self.call(**args)
          new(**args).call
        end

        def initialize(patient:, treatment_node:, user:, session: nil)
          @patient = patient
          @treatment_node = treatment_node
          @user = user
          @session = session || Renalware::HD::Session::Closed.new
        end

        def call
          assign_top_level_attributes
          build_info
          build_dialysis
          build_observations_before
          build_observations_after
          build_hdf
          byebug
          session
        end

        private

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

        def hospital_unit
          dialysis_unit.hospital_unit
        end

        def dialysis_unit
          HD::ProviderUnit.find_by!(providers_reference: treatment_node.ClinicId)
        end

        def dialysate
          raise Errors::DialysateMissingError if treatment_node.Dialysate.blank?

          Renalware::HD::Dialysate.find_by!(name: treatment_node.Dialysate)
        rescue ActiveRecord::RecordNotFound
          raise Errors::DialysateNotFoundError, treatment_node.Dialysate
        end

        def access_type
          AccessMap.for(
            diaverum_location: treatment_node.AccessLocationId,
            diaverum_type: treatment_node.AccessTypeId
          )
        end

        def hd_type
          HDTypeMap.for(diaverum_type_id: treatment_node.TypeId)
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
# rubocop:enable Metrics/AbcSize, Metrics/ClassLength, Metrics/MethodLength
