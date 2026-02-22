source "https://rubygems.org"

gemspec

rails_version = ENV.fetch("RAILS_VERSION", "7.0")
rails_main = rails_version == "main"

if rails_main
  gem "rails", github: "rails/rails"
else
  gem "rails", "~> #{rails_version}.0"
end

gem "sprockets-rails"

gem "rake"
gem "byebug"
gem "puma"

group :development, :test do
  if rails_main
    gem "sqlite3", ">= 1.4"
  else
    gem "sqlite3", "~> 1.4"
    gem "concurrent-ruby", "< 1.3.5"
  end

  gem "importmap-rails"
end

group :test do
  gem "capybara"
  gem "rexml"
  if rails_main
    gem "selenium-webdriver", ">= 4.11", "< 4.20"
  else
    gem "selenium-webdriver", "< 4.11"
    gem "webdrivers"
  end
end
