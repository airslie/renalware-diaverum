# frozen_string_literal: true

require "renalware"
require "dotenv-rails"

module Renalware
  module Diaverum
    def self.table_name_prefix
      "renalware_diaverum."
    end

    class Engine < ::Rails::Engine
      isolate_namespace Renalware::Diaverum
    end
  end
end
