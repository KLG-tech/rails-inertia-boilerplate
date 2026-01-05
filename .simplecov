# frozen_string_literal: true

# SimpleCov configuration for code coverage
# https://github.com/simplecov-ruby/simplecov

SimpleCov.start "rails" do
  # Set minimum coverage threshold (optional)
  # minimum_coverage 90

  # Enable branch coverage (Ruby 2.5+)
  enable_coverage :branch

  # Add coverage groups
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Helpers", "app/helpers"
  add_group "Mailers", "app/mailers"
  add_group "Jobs", "app/jobs"
  add_group "Services", "app/services"
  add_group "Policies", "app/policies"
  add_group "Libraries", "lib"

  # Exclude files from coverage
  add_filter "/test/"
  add_filter "/spec/"
  add_filter "/config/"
  add_filter "/db/"
  add_filter "/vendor/"

  # Use a custom formatter if needed
  # formatter SimpleCov::Formatter::HTMLFormatter

  # For parallel tests, merge results
  if ENV["CI"]
    formatter SimpleCov::Formatter::SimpleFormatter
  end

  # Track files even if they're not required during tests
  track_files "{app,lib}/**/*.rb"
end
