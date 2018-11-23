# frozen_string_literal: true

if Rails.env.development?
  require Renalware::Engine.root.join("spec/dummy/db/seeds")
  require Renalware::Diaverum::Engine.root.join("demo_data", "seeds")
end
