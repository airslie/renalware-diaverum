# frozen_string_literal: true

require "benchmark"

namespace :diaverum do
  namespace :db do
    namespace :demo do
      desc "Loads demo seeds from renalware-core then adds renalware-diaverum demo seeds"
      task seed: :environment do
        if Rails.env.development?
          require Renalware::Diaverum::Engine.root.join("demo_data", "seeds")
        else
          puts "Task currently only possible in development environment"
        end
      end
    end
  end
end
