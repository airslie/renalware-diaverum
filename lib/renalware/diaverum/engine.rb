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

      initializer :resolve_scenic_views_inside_engine do |app|
        # Set app.config.paths["db/views"] to the engine's db/views path so (our monkey-patched)
        # scenic will load views from the engine (otherwise not supported unless manually copies in
        # a rake task, which I am keen to avoid)
        # See lib/core_extensions/scenic.rb
        %w(views functions triggers).each do |db_thing|
          dir = Rails.root.join(config.root, "db", db_thing)
          app.config.paths.add("db/#{db_thing}", with: dir)
        end
      end
    end
  end
end
