# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Diaverum
    module Incoming
      class SessionBuilderFactory
        def self.builder_for(treatment_node:, **args)
          return if treatment_node.nil?

          # DNA means did not attend
          builder_klass = if treatment_node.StartTime.present?
                            ClosedSessionBuilder
                          else
                            DNASessionBuilder
                          end
          builder_klass.new(treatment_node: treatment_node, **args)
        end
      end
    end
  end
end
