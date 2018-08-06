# frozen_string_literal: true

module Renalware
  module Diaverum
    class Paths
      class << self
        def outgoing
          root_path.join("out")
        end

        def outgoing_archive
          root_path.join("out_archive")
        end

        def incoming
          root_path.join("in")
        end

        def incoming_archive
          root_path.join("in_archive")
        end

        def root_path
          Pathname(ENV.fetch("DIAVERUM_FOLDER"))
        end

        def setup
          FileUtils.mkdir_p(outgoing) unless Dir.exist?(outgoing)
          FileUtils.mkdir_p(outgoing_archive) unless Dir.exist?(outgoing_archive)
          FileUtils.mkdir_p(incoming) unless Dir.exist?(incoming)
          FileUtils.mkdir_p(incoming_archive) unless Dir.exist?(incoming_archive)
        end
      end
    end
  end
end
