# frozen_string_literal: true

Renalware::Diaverum::Engine.routes.draw do
  defaults format: :xml do
    get "/hospital_units/:unit_id/patients", to: "patients#index", as: :diaverum_patients
    get "/hospital_units/:unit_id/patients/:id", to: "patients#show", as: :diaverum_patient
  end
end
