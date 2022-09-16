source "https://rubygems.org"

gemspec

rails_version = ENV.fetch("RAILS_VERSION", "6.1")

if rails_version == "main"
  rails_constraint = { github: "rails/rails" }
else
  rails_constraint = "~> #{rails_version}.0"
end

gem "rails", rails_constraint
gem "sprockets-rails"
gem "turbo-rails", github: "hotwired/turbo-rails", branch: "turbo-7-2-0"

gem "rake"
gem "byebug"
gem "puma"

group :development, :test do
  gem "sqlite3"
  gem "importmap-rails"
end

group :test do
  gem "capybara"
  gem "rexml"
  gem "selenium-webdriver"
  gem "webdrivers"
end
