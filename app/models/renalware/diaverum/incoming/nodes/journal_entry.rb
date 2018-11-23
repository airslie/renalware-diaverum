# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      module Nodes
        # Wraps an JournalEntry XML node which has have Date, Name, Type and Text elements.
        # Type can be e.g. 'Treatmnt Note' or 'Daily Note'
        class JournalEntry < Node
          # We use this accessor to indicate the JournalEntry's Text content has been included in
          # the notes field of a session (or potentially but not >1 sessions on the same date)
          # because the Treatment/Date == JournalEntry/Date.
          attr_accessor :included_in_session_notes
          alias :included_in_session_notes? :included_in_session_notes
        end
      end
    end
  end
end
