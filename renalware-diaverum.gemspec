# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "renalware/diaverum/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "renalware-diaverum"
  s.version     = Renalware::Diaverum::VERSION
  s.authors     = ["Airslie"]
  s.email       = ["dev@airslie.com"]
  s.homepage    = "https://github.com/airslie/renalwarev-diaverum"
  s.summary     = "Diaverum integration for Renalware 2"
  s.description = "Adds support for ingesting HD Sessions from Diaverum dialysers via iRIMS "\
                  "and exporting patient XML in order to keep the two systems in sync."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "dotenv-rails"
  s.add_dependency "pg", "~> 1.0"
  s.add_dependency "rails", ">= 5.1"
end
