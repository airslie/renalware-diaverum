
# frozen_string_literal: true

require "active_support/concern"

module Renalware
  module Diaverum::Logging
    extend ActiveSupport::Concern

    def logger
      @logger ||= Logger.new(
        (Rails.env.test? || Rails.env.development?) ? STDOUT : Rails.root.join("log", "diaverum.log")
      )
    end

    def logger=(logger)
      @logger = logger
    end
  end
end
