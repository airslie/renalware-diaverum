# frozen_string_literal: true

source "https://rubygems.org"
source "https://rails-assets.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 2.6.3"

gemspec

gem "babel-transpiler"
gem "nhs_api_client", github: "airslie/nhs_api_client", require: false
gem "renalware-core", github: "airslie/renalware-core", submodules: true
gem "trix", github: "airslie/trix"

group :development, :test do
  gem "awesome_print"
  gem "bootsnap"
  gem "bundler-audit", require: false
  gem "byebug"
  gem "climate_control"
  gem "equivalent-xml"
  gem "factory_bot_rails", require: false
  gem "faker"
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
