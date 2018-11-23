# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      class LogUnassignedJournalEntries
        pattr_initialize [:entries!]

        def self.call(**args)
          new(**args).call
        end

        def call
          # TODO: log out entries
        end
      end
    end
  end
end
