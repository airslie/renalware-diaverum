# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Diaverum::Configuration do
    include Diaverum::ConfigurationHelpers

    subject(:config) { Diaverum.config }

    describe "#diaverum_incoming_skip_session_save" do
      subject{ config.diaverum_incoming_skip_session_save }

      context "when it is any value other than 'false' in ENV" do
        it "it defaults to true" do
          %w(true x 123).each do |value|
            with_modified_env(DIAVERUM_INCOMING_SKIP_SESSION_SAVE: value) do
              expect(Diaverum.config.diaverum_incoming_skip_session_save).to eq(true)
            end
          end
        end
      end

      context "when it is 'false' in ENV" do
        it "is false" do
          with_modified_env(DIAVERUM_INCOMING_SKIP_SESSION_SAVE: "false") do
            expect(Diaverum.config.diaverum_incoming_skip_session_save).to eq(false)
          end
        end
      end
    end

    describe "#diaverum_go_live_date" do
      it "raises an error if the date is invalid" do
        expect{
          with_modified_env(DIAVERUM_GO_LIVE_DATE: "baddate") {}
        }.to raise_error(ArgumentError)
      end

      it "returns a Date object" do
        with_modified_env(DIAVERUM_GO_LIVE_DATE: "2018-12-01") do
          expect(Diaverum.config.diaverum_go_live_date).to eq(Date.parse("2018-12-01"))
        end
      end
    end
  end
end
