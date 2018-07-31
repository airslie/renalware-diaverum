# frozen_string_literal: true

require "active_support/concern"

module Renalware
  module Diaverum::Logging
    extend ActiveSupport::Concern

    def logger
      @logger ||= begin
        if Rails.env.test? || Rails.env.development?
          Logger.new(STDOUT)
        else
          Logger.new(Rails.root.join("log", "diaverum.log"))
        end
      end
    end

    def logger=(logger)
      @logger = logger
    end
  end
end
