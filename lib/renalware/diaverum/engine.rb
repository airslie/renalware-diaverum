require "renalware"

module Renalware
  module Diaverum
    class Engine < ::Rails::Engine
      isolate_namespace Renalware::Diaverum

      # Don't have prefix method return anything.
      # This will keep Rails Engine from generating all table prefixes with the engines name
      def self.table_name_prefix; end
    end
  end
end
