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

      initializer :append_migrations do |app|
        # Prevent duplicate migrations if we are db:migrating at the engine level (eg when
        # running tests) rather than the host app
        running_in_dummy_app = Dir.pwd.ends_with?("dummy")
        running_outside_of_engine = app.root.to_s.match(root.to_s + File::SEPARATOR).nil?

        if running_in_dummy_app || running_outside_of_engine
          engine_migration_paths = config.paths["db/migrate"]
          app_migration_paths =  app.config.paths["db/migrate"]

          engine_migration_paths.expanded.each do |expanded_path|
            app_migration_paths << expanded_path
          end
        end
      end
    end
  end
end
