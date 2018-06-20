namespace :db do
  namespace :demo do
    desc "Loads demo seed data from the renalware-core gem"
    task seed: :environment do
      if Rails.env.development?
        require Renalware::Engine.root.join("spec/dummy/db/seeds")
      else
        puts "Task currently only possible in development environment"
      end
    end
  end
end
namespace :db do
  namespace :demo do
    desc "Loads demo seed data from the renalware-core gem"
    task seed: :environment do
      if Rails.env.development?
        require Renalware::Engine.root.join("spec/dummy/db/seeds")
      else
        puts "Task currently only possible in development environment"
      end
    end
  end
end
