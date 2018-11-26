# frozen_string_literal: true

require "rails_helper"
require "tmpdir"

module Renalware
  module Diaverum
    RSpec.describe Incoming::LogUnassignedJournalEntries do
      describe ".call" do
        it "logs JournalEntrys that have not been appended to a session's notes because "\
            "no session was found having a matching date" do
          warnings = instance_double(Array, "<<": nil)
          log = instance_double(HD::TransmissionLog, warnings: warnings, save!: true)
          journal_entries = [
            instance_double(
              Incoming::Nodes::JournalEntry,
              to_xml: "<somexml/>",
              included_in_session_notes: false
            )
          ]

          described_class.new(log: log, journal_entries: journal_entries).call

          expect(warnings).to have_received(:<<).with("Unused JournalEntry: <somexml/>")
          expect(log).to have_received(:save!)
        end
      end
    end
  end
end
