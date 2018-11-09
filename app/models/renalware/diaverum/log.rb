# frozen_string_literal: true

module Renalware
  module Diaverum
    # Targets a Postgres view called renalware_diaverum.logs
    # TODO: Write tests inc the ordering of data (parent then child) in the view.
    class Log < ApplicationRecord
      scope :for_batch, ->(uuid) { where(uuid: uuid) }
      scope :incoming, -> { where(direction: :in) }
      scope :outgoing, -> { where(direction: :out) }
    end
  end
end
