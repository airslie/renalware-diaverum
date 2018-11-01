# frozen_string_literal: true

module Renalware
  module Diaverum
    class Paths
      class << self
        # Outgoing will probably be a symlink to /media/diaverum/outgoing
        def outgoing
          root_path.join("outgoing")
        end

        # Incoming will probably be a symlink to /media/diaverum/incoming
        def incoming
          root_path.join("incoming")
        end

        def outgoing_archive
          archive.join("outgoing")
        end

        def incoming_archive
          archive.join("incoming")
        end

        def archive
          root_path.join("archive")
        end

        def root_path
          Pathname(ENV.fetch("DIAVERUM_FOLDER")) # e.g. /var/diaverum
        end

        def setup
          create_folder_if_not_exists(incoming)
          create_folder_if_not_exists(outgoing)
          create_folder_if_not_exists(archive)
          create_folder_if_not_exists(outgoing_archive)
          create_folder_if_not_exists(incoming_archive)
        end

        def create_folder_if_not_exists(name)
          FileUtils.mkdir_p(name) unless File.exist?(name)
        end
      end
    end
  end
end
