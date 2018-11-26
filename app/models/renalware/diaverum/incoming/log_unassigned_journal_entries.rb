# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      class LogUnassignedJournalEntries
        pattr_initialize [:journal_entries!, :log!]

        def self.call(**args)
          new(**args).call
        end

        def call
          return if journal_entries.blank? || Array(journal_entries).empty?

          build_warning_messages
          log.save!
        end

        private

        def build_warning_messages
          Array(journal_entries).each do |entry|
            log.warnings << "Unused JournalEntry: #{entry.to_xml}"
          end
        end
      end
    end
  end
end
