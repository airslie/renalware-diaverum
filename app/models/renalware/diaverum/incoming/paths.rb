# frozen_string_literal: true

module Renalware
  module Diaverum
    module Incoming
      class Paths
        attr_reader :home, :archive, :error

        def initialize
          @home = Pathname(ENV.fetch("DIAVERUM_FOLDER", default_path))
          @archive = @home.join("archive")
          @error = @home.join("error")
          FileUtils.mkdir_p(@archive)
          FileUtils.mkdir_p(@error)
        end

        private

        def default_path
          Rails.root.join("tmp", "diaverum")
        end
      end
    end
  end
end
