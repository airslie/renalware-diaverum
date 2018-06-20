#require_dependency "renalware/diaverum"
Renalware::Diaverum::Engine.routes.draw do

  defaults format: :xml do
    get "/hospital_units/:unit_id/patients", to: "patients#index", as: :diaverum_patients
    get "/hospital_units/:unit_id/patients/:id", to: "patients#show", as: :diaverum_patient
  end

  # resources :units, only: [] do
  #   resources :patients, only: [:index, :show]
  # end
end
