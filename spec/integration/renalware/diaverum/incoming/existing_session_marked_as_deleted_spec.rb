# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      include Diaverum::ConfigurationHelpers

      describe "Mark a previously imported session as Deleted" do
        context "when session was prevously imported (it has an external_id assigned)" do
          let(:existing_session) { create(:hd_closed_session, external_id: 123) }

          context "when the same session appears in the 30 day backlog" do
            context "when the new session is not marked as deleted" do
              it "does not change the session" do
                existing_session
                log = instance_double(HD::TransmissionLog, update!: nil)
                treatment_node = instance_double(
                  Nodes::Treatment,
                  Deleted: 0,
                  TreatmentId: "123",
                  to_xml: nil
                )
                service = SavePatientSession.new(
                  patient: nil,
                  treatment_node: treatment_node,
                  log: log,
                  patient_node: nil
                )

                expect{
                  service.call
                }.not_to change(existing_session, :updated_at)

                expect(HD::Session.where(id: existing_session.id).count).to eq(1)
              end
            end

            context "when the incoming session is marked as deleted" do
              it "soft deletes the session" do
                existing_session
                log = instance_double(HD::TransmissionLog, update!: nil)
                treatment_node = instance_double(
                  Nodes::Treatment,
                  Deleted: 1,
                  TreatmentId: "123",
                  to_xml: nil
                )
                service = SavePatientSession.new(
                  patient: nil,
                  treatment_node: treatment_node,
                  log: log,
                  patient_node: nil
                )

                service.call

                # Should have hard deleted the session
                expect(HD::Session.where(id: existing_session.id).count).to eq(0)
              end
            end
          end
        end
      end
    end
  end
end
