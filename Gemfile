ruby "2.5.0"

source "https://rubygems.org"

gemspec

gem "byebug"
gem "dotenv-rails", "2.4.0"
gem "faker"
gem "fuubar"
gem "renalware-core", path: "../renalwarev2"
gem "rspec-rails"
gem "shoulda-matchers"

# devise_security_extension
# Because we can't include git reference in the gemspec in renalware, for now include it here
# (its also in the renalware Gemfile which applies only to running renalware tests or running
# up the spec/dummy app)
gem "devise_security_extension", git: "https://github.com/phatworx/devise_security_extension.git"
