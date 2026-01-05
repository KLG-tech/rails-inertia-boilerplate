# frozen_string_literal: true

# Bullet configuration for N+1 query detection
# https://github.com/flyerhzm/bullet

if defined?(Bullet)
  Rails.application.configure do
    config.after_initialize do
      Bullet.enable = true

      # Show bullet alerts in the browser
      Bullet.alert = true

      # Log N+1 queries to the Rails log
      Bullet.bullet_logger = true

      # Log to the browser console
      Bullet.console = true

      # Add warnings to the Rails log
      Bullet.rails_logger = true

      # Add errors to the browser footer
      Bullet.add_footer = true

      # Raise an error when N+1 queries are detected (useful for tests)
      # Bullet.raise = true

      # Ignored detector checks (add as needed)
      # Bullet.stacktrace_includes = []
      # Bullet.stacktrace_excludes = []
    end
  end
end
