RSpec.describe "Ingest HD Session from Diaverum ", type: :feature do
  let(:system_user) { create(:user, username: Renalware::SystemUser.username) }
  let(:patient) { create(:hd_patient, local_patient_id: "KCH123", nhs_number: "0123456789") }
  let(:hospital_unit) { create(:hospital_unit) }
  let(:dialysate) { create(:hd_dialysate) }

  def create_xml_file_from_fixture(fixture_name)
    fixture = file_fixture("hd/diaverum/#{fixture_name}.xml.erb")
    xml_content = ERB.new(xml_filepath.read).result(binding)
    xml_filepath = File.join(ENV["DIAVERUM_FOLDER"], "#{fixture_name}.xml")
    File.write(xml_filepath, xml_content)
  end

  before do
    # Write up the Diaverum path somewhere safe
    path = Rails.root.join("tmp", "diaverum")
    FileUtils.mkdir_p(path)
    ENV["DIAVERUM_FOLDER"] = path.to_s
  end

  context "when Diaverum @ St Albans has SFTPed multiple patient XML files, each containing up to "\
          "30 calendar days of HD Session (aka Treament) history, "\
          "and a rake task has iterated over the files and passed us a single file to import" do

    context "when we can identifiy the patient, and the all the sessions in the file are new ones "\
            "e.g. because this is a new patient, or the rake task is running for the first time "\
            "and needs to catchup on the (up to 30 days of) backlog" do

      let(:xml_filepath) { file_fixture("hd/diaverum/example.xml.erb") }
      let(:doc) do
        # Set up an erb template based on the XML fixture so we can insert patient identifiers
        # into the XML.By magic, the patient variable is in binding so can be resolved in the ERB
        # template
        xml = ERB.new(xml_filepath.read).result(binding)
        Nokogiri::XML(xml)
      end

      it "meta test: fixture rendered via ERB contains patient data bound via 'patient' variable" do
        payload = Diaverum::PatientXmlDocument.new(doc)

        expect(payload.local_patient_id).to eq(patient.local_patient_id)
        expect(payload.nhs_number).to eq(patient.nhs_number)
      end

      it "creates a new HD session for each session in the file" do
        system_user
        p dialysate.id
        payload = Diaverum::PatientXmlDocument.new(doc)
        create_xml_file_from_fixture(:example)

        expect{
          Diaverum::SavePatientSessions.new(payload).call
        }.to change(patient.hd_sessions.open, :count).by(2)
      end
    end
  end

  describe Diaverum::PatientXmlDocument do
    subject { described_class.new(xml) }

    describe ".root" do
      context "when the root element is not 'Patients'" do
        let(:xml) { Nokogiri::XML("<Fish></Fish>") }

        it { expect{ subject }.to raise_error(DiaverumXMLParsingError) }
      end
    end

    context "when there are no Patient elements" do
      let(:xml) { Nokogiri::XML("<Patients></Patients>") }

      it { expect{ subject }.to raise_error(DiaverumXMLParsingError) }
    end

    context "when there are > 1 Patient elements" do
      let(:xml) { Nokogiri::XML("<Patients><Patient/><Patient/></Patients>") }

      it { expect{ subject }.to raise_error(DiaverumXMLParsingError) }
    end

    context "when there is 1 Patient element" do
      let(:xml) { Nokogiri::XML("<Patients><Patient/></Patients>") }

      it { expect{ subject }.not_to raise_error }
    end

    # TODO: Could test an error raised when
    # - HospitalNumber missing
    # - ExternalPatientId (NHS NUmber) missing
    # However these are unlikely

    # TODO: test SessionXmlDocument.external_id
  end
end

describe "rake hd:diaverum:ingest", type: :task do
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

        allow(Diaverum::SavePatientSessions).to receive(:call)

        expect {
          task.execute
        }.to output("Ingesting Diaverum HD Sessions\n1.xml...OK\n2.xml...OK\n").to_stdout

        expect(Diaverum::SavePatientSessions).to have_received(:call).exactly(:twice)

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
          allow(Diaverum::SavePatientSessions)
            .to receive(:call).and_raise(ArgumentError.new("BOOM"))

          expect {
            task.execute
          }.to output("Ingesting Diaverum HD Sessions\n1.xml...FAIL\n").to_stdout

          expect(Diaverum::SavePatientSessions).to have_received(:call).exactly(:once)

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
