# frozen_string_literal: true

ruby "2.5.0"

source "https://rubygems.org"
source "https://rails-assets.org"

gemspec

gem "dotenv-rails", "2.4.0"
# gem "renalware-core", path: "../renalwarev2"
gem "renalware-core",
    git: "https://github.com/airslie/renalware-core.git",
    path: "../renalwarev2"
# branch: "chore/hd/diaverum_support"
# path: "../renalwarev2"
# branch: "chore/hd/diaverum_support"
# tag: "v2.0.35",

# devise_security_extension
# Because we can't include git reference in the gemspec in renalware, for now include it here
# (its also in the renalware Gemfile which applies only to running renalware tests or running
# up the spec/dummy app)
gem "devise_security_extension", git: "https://github.com/phatworx/devise_security_extension.git"

group :development, :test do
  gem "bootsnap"
  gem "bundler-audit", require: false
  gem "byebug"
  gem "equivalent-xml"
  gem "factory_bot_rails", require: false
  gem "faker"
  gem "fuubar"
  gem "rspec-rails"
  gem "rspec_junit_formatter", "~> 0.3.0"
  gem "rubocop"
  gem "shoulda-matchers"
  gem "webmock", require: false
end
