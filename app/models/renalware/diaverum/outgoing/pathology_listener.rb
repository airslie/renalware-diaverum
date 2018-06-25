# frozen_string_literal: true

module Renalware
  module Diaverum
    module Outgoing
      class PathologyListener
        def message_processed(feed_message:, **)
          ForwardHl7MessageJob.perform_later(message: feed_message)
        end
      end
    end
  end
end
