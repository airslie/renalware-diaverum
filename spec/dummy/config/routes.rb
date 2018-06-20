# frozen_string_literal: true

# Routes for spec/dummy app
Rails.application.routes.draw do
  mount Renalware::Diaverum::Engine => "/diaverum"
  mount Renalware::Engine => "/"
end
