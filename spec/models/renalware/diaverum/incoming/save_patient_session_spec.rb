# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      RSpec.describe SavePatientSession do
        include DiaverumHelpers

        # let!(:system_user) { create(:user, username: SystemUser.username) }
        let(:patient) { create(:hd_patient, local_patient_id: "KCH123", nhs_number: "0123456789") }
        let(:hospital_unit) { create(:hospital_unit) }
        let(:dialysate)     { create(:hd_dialysate) }
        let(:provider)      { HD::Provider.create!(name: "Diaverum") }
        let(:dialysis_unit) do
          HD::ProviderUnit.create!(
            hospital_unit: hospital_unit,
            hd_provider: provider,
            providers_reference: "123"
          )
        end

        let(:transmission_log) do
          HD::TransmissionLog.create!(
            direction: :in,
            format: :xml
          )
        end

        before { Diaverum.config.diaverum_incoming_skip_session_save = false }
        around(:each){ |example| using_a_tmp_diaverum_path{ example.run } }

        let(:xml_filepath) { file_fixture("diaverum_example.xml.erb") }
        let(:doc) do
          # Set up an erb template based on the XML fixture so we can insert patient identifiers
          # into the XML.By magic, the patient variable is in binding so can be resolved in
          # the ERB template
          xml = ERB.new(xml_filepath.read).result(binding)
          Nokogiri::XML(xml)
        end
        let(:payload) { PatientXmlDocument.new(doc) }

        it "meta test: there should be 2 sessions in the XML file" do
          expect(payload.session_nodes.count).to eq(2)
        end
      end
    end
  end
end
