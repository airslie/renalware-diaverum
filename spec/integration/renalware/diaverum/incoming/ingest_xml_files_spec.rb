# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      describe "rake diaverum:ingest", type: :task do
        let(:patient) { create(:hd_patient, local_patient_id: "KCH123", nhs_number: "0123456789") }

        it "preloads the Rails environment" do
          expect(task.prerequisites).to include "environment"
        end

        it "runs gracefully with with no files found" do
          using_a_tmp_diaverum_path do
            expect { task.execute }.not_to raise_error
          end
        end

        it "logs to stdout" do
          using_a_tmp_diaverum_path do
            expect {
              task.execute
            }.to output(/Ingesting Diaverum HD Sessions/).to_stdout_from_any_process
          end
        end

        context "when there a patient XML file waiting in the incoming folder having 10 sessions" do
          context "when the file is valid" do
            it "imports all the sessions and moves/creates necessary files" do
              using_a_tmp_diaverum_path do
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
          end

          context "when the file is NOT valid" do
            it "imports any sessions it can and moves/creates necessary files" do
              using_a_tmp_diaverum_path do
                copy_example_xml_file_into_diaverum_in_folder
                # now delete all dialysates so we'll get a missing dialysate error
                HD::Dialysate.delete_all

                task.execute

                expect(HD::TransmissionLog.count).to eq(3) # a top level log and one per session
                expect(HD::TransmissionLog.pluck(:error_messages).uniq.flatten)
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
        end

        def copy_example_xml_file_into_diaverum_in_folder
          File.write(
            Paths.incoming.join("diaverum_example.xml"),
            create_patient_xml_document.to_xml
          )
        end

        def create_patient_xml_document(options: {})
          erb_template = options.fetch(
            :erb_template,
            Engine.root.join("spec", "fixtures", "files", "diaverum_example.xml.erb")
          )
          system_user = create(:user, username: SystemUser.username)
          access_map = AccessMap.create!(
            diaverum_location_id: "LEJ",
            diaverum_type_id: 7,
            access_type: create(:access_type),
            side: :left
          )
          hospital_unit = create(:hospital_unit)
          dialysate = create(:hd_dialysate)
          provider = HD::Provider.create!(name: "Diaverum")
          dialysis_unit = HD::ProviderUnit.create!(
            hospital_unit: hospital_unit,
            hd_provider: provider,
            providers_reference: "123"
          )
          xml_filepath = Engine.root.join("spec", "fixtures", "files", "diaverum_example.xml.erb")
          xml_string = ERB.new(xml_filepath.read).result(binding)
          Nokogiri::XML(xml_string)
        end

        def using_a_tmp_diaverum_path
          Dir.mktmpdir do |dir|
            p dir
            ENV["DIAVERUM_FOLDER"] = dir
            Paths.setup
            yield
          end
        end
      end
    end
  end
end
