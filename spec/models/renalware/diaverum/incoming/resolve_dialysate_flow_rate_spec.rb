# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      describe ResolveDialysateFlowRate do
        let(:patient) { nil }

        dialysate_flow_examples = [
          { session: "DF_S", prescription: "DF_P",  hd_profile: "DF_HDP", expected: "DF_S"   },
          { session: "",     prescription: "DF_P",  hd_profile: "DF_HDP", expected: "DF_P"   },
          { session: nil,    prescription: "DF_P",  hd_profile: "DF_HDP", expected: "DF_P"   },
          { session: "",     prescription: "",      hd_profile: "DF_HDP", expected: "DF_HDP" },
          { session: "",     prescription: nil,     hd_profile: "DF_HDP", expected: "DF_HDP" },
          { session: "",     prescription: nil,     hd_profile: "",       expected: "" },
          { session: "",     prescription: nil,     hd_profile: nil,      expected: nil }
        ]
        dialysate_flow_examples.each do |hash|
          dialysate_flow = OpenStruct.new(hash)

          it "asas" do
            treatment_node = instance_double(
              SessionXmlDocument,
              DialysateFlow: dialysate_flow.session
            )
            prescription_node = instance_double(
              Nodes::Prescription,
              DialysateFlow: dialysate_flow.prescription
            )
            patient_node = instance_double(
              PatientXmlDocument,
              current_dialysis_prescription: prescription_node
            )
            # Using .new not instance_double to get the document hash loaded into a Document object
            hd_profile = HD::Profile.new(
              document: { dialysis: { flow_rate: dialysate_flow.hd_profile } }
            )
            # allow(HD::Profile).to receive(:for_patient).and_return(hd_profile)
            # allow(HD).to receive(:cast_patient).and_return(patient)
            allow(patient).to receive(:current_profile).and_return(hd_profile)

            actual_dialysate_flow = described_class.new(
              patient: patient,
              patient_node: patient_node,
              treatment_node: treatment_node
            ).call

            expect(actual_dialysate_flow).to eq(dialysate_flow.expected)
          end
        end
      end
    end
  end
end
