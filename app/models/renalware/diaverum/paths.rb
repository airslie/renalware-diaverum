# frozen_string_literal: true

module Renalware
  module Diaverum
    class Paths
      class << self
        def outgoing
          Pathname(Renalware::Diaverum.config.diaverum_outgoing_path)
        end

        def incoming
          Pathname(Renalware::Diaverum.config.diaverum_incoming_path)
        end

        def outgoing_archive
          Pathname(Renalware::Diaverum.config.diaverum_outgoing_archive_path)
        end

        def incoming_archive
          Pathname(Renalware::Diaverum.config.diaverum_incoming_archive_path)
        end
      end
    end
  end
end
