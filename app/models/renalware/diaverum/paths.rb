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
          create_folder_if_not_exists(outgoing)
          create_folder_if_not_exists(outgoing_archive)
          create_folder_if_not_exists(incoming)
          create_folder_if_not_exists(incoming_archive)
        end

        def create_folder_if_not_exists(name)
          FileUtils.mkdir_p(name) unless Dir.exist?(name)
        end
      end
    end
  end
end
