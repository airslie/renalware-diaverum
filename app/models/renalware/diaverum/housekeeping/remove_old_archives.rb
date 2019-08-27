# frozen_string_literal: true

require_dependency "renalware/ukrdc"
require "attr_extras"

module Renalware
  module Diaverum
    module Housekeeping
      # Responsible for removing outgoing and incoming archive files older than the configured
      # number of days. Called from a housekeeping rake task.
      class RemoveOldArchives
        def call
          remove_old_archives(Paths.incoming_archive)
          remove_old_archives(Paths.outgoing_archive)
        end

        private

        def remove_old_archives(archive_folder)
          log(<<-MSG.squish)
            Removing archived files in #{archive_folder}
            older than #{diaverum_num_days_to_keep_archives} days
          MSG
          pattern = archive_folder.join("*.*")
          Dir.glob(pattern).each do |filename|
            archive_file = ArchiveFile.new(filename)
            if archive_file.age_in_days > diaverum_num_days_to_keep_archives
              log " Deleting #{filename} age: #{archive_file.age_in_days} days"
              File.delete(filename)
            end
          end
        end

        def log(msg)
          Rails.logger.info(" " + msg)
        end

        def diaverum_num_days_to_keep_archives
          Diaverum.config.diaverum_num_days_to_keep_archives.to_i
        end

        def glob_file_for_folder(folder)
          folder.join("*.xml")
        end

        class ArchiveFile
          pattr_initialize :path

          def age_in_days
            (Time.zone.now - File.stat(path).mtime).to_i / (24 * 3600)
          end
        end
      end
    end
  end
end
