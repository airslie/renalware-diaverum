# frozen_string_literal: true

ruby "2.6.3"

source "https://rubygems.org"
source "https://rails-assets.org"

gemspec

gem "dotenv-rails", "~> 2.5.0"
gem "renalware-core",
    git: "https://github.com/airslie/renalware-core.git",
    branch: "master"

# The main trix gem at https://github.com/maclover7/trix is not yet Rails 5.2 compatible; it give
# an argument error when calling f.trix_editor due to a Rails 5.2 ActionView change.
# For now use this fork until the upstream has been fixed (this line will also need to appear in
# each hospital's Gemfile for now)
gem "trix",
    git: "https://github.com/airslie/trix.git",
    branch: "master"

gem "nhs_api_client",
    require: false,
    git: "https://github.com/airslie/nhs_api_client.git"

# devise_security_extension
# Because we can't include git reference in the gemspec in renalware, for now include it here
# (its also in the renalware Gemfile which applies only to running renalware tests or running
# up the spec/dummy app)
gem "devise_security_extension",
  git: "https://github.com/phatworx/devise_security_extension.git"

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
  gem "rubocop-rspec", require: false
  gem "shoulda-matchers"
  gem "webmock", require: false
end

group :test do
  gem "capybara"
  gem "capybara-screenshot"
end
