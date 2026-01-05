source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.1"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.5"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Vite.js integration for Rails [https://vite-ruby.netlify.app/]
gem "vite_rails"
# Inertia.js adapter for Rails [https://inertia-rails.netlify.app/]
gem "inertia_rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use good_job for background job processing [https://github.com/bensheldon/good_job]
gem "good_job", "~> 4.0"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

# Production readiness gems
# APM monitoring [https://docs.newrelic.com/docs/agents/ruby-agent/]
gem "newrelic_rpm"
# Rate limiting and throttling [https://github.com/rack/rack-attack]
gem "rack-attack"
# CORS handling [https://github.com/cyu/rack-cors]
gem "rack-cors"
# Structured logging [https://github.com/roidrage/lograge]
gem "lograge"
# Fast pagination [https://github.com/ddnexus/pagy]
gem "pagy"

# Authentication with Devise and Keycloak OAuth
gem "devise"
gem "omniauth-keycloak"
gem "omniauth-rails_csrf_protection"

# Role management [https://github.com/RolifyCommunity/rolify]
gem "rolify"
# Policy-based authorization [https://github.com/varvet/pundit]
gem "pundit"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Load environment variables from .env file [https://github.com/bkeepers/dotenv]
  gem "dotenv-rails"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Git hooks manager [https://github.com/evilmartians/lefthook]
  gem "lefthook", require: false

  # Annotate models, fixtures, and tests with schema information
  gem "annotaterb"

  # N+1 query detection
  gem "bullet"

  # Enhanced Rails console with Pry
  gem "pry-rails"

  # Better error pages with source code inspection
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"

  # Code coverage for Ruby
  gem "simplecov", require: false

  # Library for stubbing and setting expectations on HTTP requests
  gem "webmock"
end
