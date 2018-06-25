# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      # RSpec.describe "Ingest HD Sessions from Diaverum using a rake task ", type: :feature do
      describe "rake diaverum:ingest", type: :task do
        before do
          # Wire up the Diaverum path somewhere safe
          path = Rails.root.join("tmp", "diaverum")
          FileUtils.mkdir_p(path)
          ENV["DIAVERUM_FOLDER"] = path.to_s
        end

        it "preloads the Rails environment" do
          expect(task.prerequisites).to include "environment"
        end

        it "runs gracefully with with no files found" do
          expect { task.execute }.not_to raise_error
        end

        it "logs to stdout" do
          expect { task.execute }.to output("Ingesting Diaverum HD Sessions\n").to_stdout
        end

        context "when there are 2 xml files waiting in the folder" do
          it "delegates work to the service object for each file, and logs the filenames" do
            Dir.mktmpdir do |dir|
              ENV["DIAVERUM_FOLDER"] = dir
              dir = Pathname(dir)

              # Create some dummy xml files to simulate those coming in from Diaverum
              (1..2).each do |idx|
                filepath = Pathname(dir).join("#{idx}.xml")
                File.write(filepath, "<Patients><Patient></Patient></Patients>")
              end

              allow(SavePatientSessions).to receive(:call)

              expect {
                task.execute
              }.to output("Ingesting Diaverum HD Sessions\n1.xml...OK\n2.xml...OK\n").to_stdout

              expect(SavePatientSessions).to have_received(:call).exactly(:twice)

              # Successfully processed files are removed from folder and moved to the archive folder
              expect(Dir.glob(dir.join("*.xml")).count).to eq(0)
              expect(Dir.glob(dir.join("archive", "*.xml")).count).to eq(2)
            end
          end

          context "when the processing of a file raises an error and cannot be ingested" do
            it "is moved to the error folder" do
              Dir.mktmpdir do |dir|
                ENV["DIAVERUM_FOLDER"] = dir
                dir = Pathname(dir)

                # Create a dummy xml file
                filepath = dir.join("1.xml")
                File.write(filepath, "<Patients><Patient></Patient></Patients>")

                # Mock the SavePatientSessions to return false to indicate failure
                # - in which case the processed files are moved to the archive folder
                allow(SavePatientSessions)
                  .to receive(:call).and_raise(ArgumentError.new("BOOM"))

                expect {
                  task.execute
                }.to output("Ingesting Diaverum HD Sessions\n1.xml...FAIL\n").to_stdout

                expect(SavePatientSessions).to have_received(:call).exactly(:once)

                # Processed files should be removed from folder and moved to the errors folder
                expect(Dir.glob(dir.join("1.xml")).count).to eq(0)
                expect(Dir.glob(dir.join("archive", "1.xml")).count).to eq(0)
                expect(Dir.glob(dir.join("error", "1.xml")).count).to eq(1)

                # We also put a file in there with the error report
                error_msg = File.read(dir.join("error", "1.xml.log"))
                expect(error_msg).to match(/BOOM/)
                expect(error_msg).to match(/ArgumentError/)
              end
            end
          end
        end
      end
    end
  end
end
