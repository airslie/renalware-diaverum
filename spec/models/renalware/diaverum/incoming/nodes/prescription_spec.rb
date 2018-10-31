# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Diaverum
    module Incoming
      module Nodes
        describe Prescription do
          subject(:prescription) { described_class.new(xml.root) }

          describe "attributes" do
            let(:xml) do
              Nokogiri::XML(<<-XML)
              <DialysisPrescription>
                <StartDate>2018-07-12</StartDate>
                <EndDate>2999-12-31</EndDate>
                <DialysateFlow>600</DialysateFlow>
              </DialysisPrescription>
              XML
            end

            it "can read the XML attribues" do
              expect(prescription.DialysateFlow).to eq("600")
            end

            describe "#valid_start_and_end_dates?" do
              subject { prescription.valid_start_and_end_dates? }

              let(:xml) do
                Nokogiri::XML(<<-XML)
                <DialysisPrescription>
                  <StartDate>#{start_date}</StartDate>
                  <EndDate>#{end_date}</EndDate>
                <DialysisPrescription>
                XML
              end

              context "when StartDate is blank" do
                let(:start_date) { nil }
                let(:end_date) { "2999-12-31" }

                it { is_expected.to eq(false) }
              end

              context "when EndDate is blank" do
                let(:start_date) { "2999-12-31" }
                let(:end_date) { nil }

                it { is_expected.to eq(false) }
              end

              context "when StartDate is not a date" do
                let(:start_date) { "bad_date" }
                let(:end_date) { "2999-12-31" }

                it { is_expected.to eq(false) }
              end

              context "when EndDate is not a date" do
                let(:start_date) { "2999-12-31" }
                let(:end_date) { "bad_date" }

                it { is_expected.to eq(false) }
              end
            end

            describe "#active?" do
              subject { prescription.active? }

              let(:xml) do
                Nokogiri::XML(<<-XML)
                <DialysisPrescription>
                  <StartDate>#{start_date}</StartDate>
                  <EndDate>#{end_date}</EndDate>
                <DialysisPrescription>
                XML
              end

              context "when a date is invalid" do
                let(:start_date) { "2999-12-31" }
                let(:end_date) { "bad_date" }

                it { is_expected.to eq(false) }
              end

              context "when StartDate is past and EndDate is past" do
                let(:start_date) { 3.days.ago }
                let(:end_date) { 1.day.ago }

                it { is_expected.to eq(false) }
              end

              context "when StartDate is today and EndDate is today" do
                let(:start_date) { Time.zone.today }
                let(:end_date) { Time.zone.today }

                it { is_expected.to eq(true) }
              end

              context "when StartDate is today and EndDate is in the future" do
                let(:start_date) { Time.zone.today }
                let(:end_date) { 1.day.from_now }

                it { is_expected.to eq(true) }
              end

              context "when StartDate is past and EndDate is in the future" do
                let(:start_date) { 1.day.ago }
                let(:end_date) { 1.day.from_now }

                it { is_expected.to eq(true) }
              end

              context "when StartDate is in the future and EndDate is in the future" do
                let(:start_date) { 1.day.from_now }
                let(:end_date) { 1.year.from_now }

                it { is_expected.to eq(false) }
              end
            end
          end
        end
      end
    end
  end
end
