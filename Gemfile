# frozen_string_literal: true

source "https://rubygems.org"
source "https://rails-assets.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.0.3"

gemspec

gem "activerecord-import"
gem "babel-transpiler"
gem "daemons", "1.2.5", require: false
gem "data_migrate"
gem "devise", "~> 4.7"
gem "dotenv-rails", "~>2.7.2" # allows us to load ENV vars from a .env file
gem "email_validator", "2.0.1"
gem "faker"
gem "loofah", "~> 2.19.1"
gem "nokogiri", "~> 1.13"
gem "party_foul", github: "airslie/party_foul" # sends errors to renalware-kch/issues on GH
gem "pg", "1.2.3"
gem "puma", "~> 5.6" # The web server which serves out content under nginx
gem "rails", "~>6.0.0"
gem "redis"
gem "ruby-hl7", "1.2.3"
gem "sassc-rails", "~> 2.1.0"
gem "strong_migrations"
gem "uglifier", "~> 4.2"
gem "tailwindcss-rails", "~> 0.5.1"
gem "terminal-table", require: false
gem "turnout", "~> 2.5.0"
gem "whenever", "~> 1.0.0"

gem "nhs_api_client", github: "airslie/nhs_api_client", require: false
gem "renalware-core", github: "airslie/renalware-core", branch: "main", submodules: true
gem "renalware-forms", github: "airslie/renalware-forms"

group :development, :test do
  gem "awesome_print"
  gem "bootsnap"
  gem "bundler-audit", require: false
  gem "byebug"
  gem "climate_control"
  gem "equivalent-xml"
  gem "factory_bot_rails", require: false
  gem "fuubar"
  gem "rspec-rails"
  gem "rspec_junit_formatter", "~> 0.3"
  gem "rubocop"
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "shoulda-matchers"
  gem "webmock", require: false
end

group :test do
  gem "capybara"
  gem "capybara-screenshot"
  gem "capybara-select-2"
end
