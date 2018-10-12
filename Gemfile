# frozen_string_literal: true

ruby "2.5.0"

source "https://rubygems.org"
source "https://rails-assets.org"

gemspec

gem "dotenv-rails", "~> 2.5.0"
gem "renalware-core", git: "https://github.com/airslie/renalware-core.git"

# The main trix gem at https://github.com/maclover7/trix is not yet Rails 5.2 compatible; it give
# an argument error when calling f.trix_editor due to a Rails 5.2 ActionView change.
# For now use this fork until the upstream has been fixed (this line will also need to appear in
# each hospital's Gemfile for now)
gem "trix",
    git: "https://github.com/airslie/trix.git",
    branch: "master"

# branch: "chore/hd/diaverum_support"
# path: "../renalwarev2"
# branch: "chore/hd/diaverum_support"
# tag: "v2.0.35",

# devise_security_extension
# Because we can't include git reference in the gemspec in renalware, for now include it here
# (its also in the renalware Gemfile which applies only to running renalware tests or running
# up the spec/dummy app)
gem "devise_security_extension",
    git: "https://github.com/phatworx/devise_security_extension.git"

group :development, :test do
  gem "bootsnap"
  gem "bundler-audit", require: false
  gem "byebug"
  gem "equivalent-xml"
  gem "factory_bot_rails", require: false
  gem "faker"
  gem "fuubar"
  gem "rspec-rails"
  gem "rspec_junit_formatter", "~> 0.3"
  gem "rubocop"
  gem "shoulda-matchers"
  gem "webmock", require: false
end
