# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      describe "rake diaverum:ingest", type: :task do
        include DiaverumHelpers
        let(:patient) { create(:hd_patient, local_patient_id: "KCH123", nhs_number: "0123456789") }

        around(:each) do |example|
          using_a_tmp_diaverum_path{ example.run }
        end

        it "preloads the Rails environment" do
          expect(task.prerequisites).to include "environment"
        end

        it "runs gracefully with with no files found" do
          expect { task.execute }.not_to raise_error
        end

        it "logs to stdout" do
          expect {
            task.execute
          }.to output(/Ingesting Diaverum HD Sessions/).to_stdout_from_any_process
        end

        context "when there a patient XML file waiting in the incoming folder having 2 sessions" do
          context "when the file is valid" do
            it "imports all the sessions and moves/creates necessary files" do
              create_hd_type_map
              copy_example_xml_file_into_diaverum_in_folder

              task.execute

              expect(HD::TransmissionLog.count).to eq(3) # a top level log and one per session
              expect(HD::TransmissionLog.pluck(:error_messages).flatten).to eq []
              expect(patient.hd_sessions.count).to eq(2)

              # Processed files are moved from incoming folder..
              expect(Dir.glob(Paths.incoming.join("*.xml")).count).to eq(0)
              # ..to the incoming archive
              expect(Dir.glob(Paths.incoming_archive.join("*.xml")).count).to eq(1)
              # ..and a summary file created - in this case ending in ok.txt as there are 0 errors
              expect(Dir.glob(Paths.incoming.join("*_ok.txt")).count).to eq(1)
            end
          end

          context "when the file is NOT valid" do
            it "imports any sessions it can and moves/creates necessary files" do
              copy_example_xml_file_into_diaverum_in_folder
              # now delete all dialysates so we'll get a missing dialysate error
              HD::Dialysate.delete_all

              task.execute

              expect(HD::TransmissionLog.count).to eq(3) # a top level log and one per session
              expect(HD::TransmissionLog.pluck(:error_messages).flatten.uniq)
                .to eq ["Couldn't find Renalware::HD::Dialysate Fresenius A7"]
              expect(patient.hd_sessions.count).to eq(0)

              # Processed files are moved from in folder..
              expect(Dir.glob(Paths.incoming.join("*.xml")).count).to eq(0)
              # ..to the incoming archive
              expect(Dir.glob(Paths.incoming_archive.join("*.xml")).count).to eq(1)
              # ..and a summary file created - in this case ending in ok.txt as there are 0 errors
              expect(Dir.glob(Paths.incoming.join("*_ok.txt")).count).to eq(0)
              expect(Dir.glob(Paths.incoming.join("*_err.txt")).count).to eq(1)

              err_file_content = Dir.glob(Paths.incoming.join("*_err.txt"))
                .map{ |p| File.read(p) }.join("")
              expect(err_file_content)
                .to match(/Couldn't find Renalware::HD::Dialysate Fresenius A7/)
            end
          end
        end

        def copy_example_xml_file_into_diaverum_in_folder
          File.write(
            Paths.incoming.join("diaverum_example.xml"),
            create_patient_xml_document.to_xml
          )
        end
      end
    end
  end
end
