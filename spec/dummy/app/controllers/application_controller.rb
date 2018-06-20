class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper Renalware::Engine.helpers
  layout "application"
end
