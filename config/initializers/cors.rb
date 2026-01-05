# frozen_string_literal: true

# Rack::Cors configuration for Cross-Origin Resource Sharing
# https://github.com/cyu/rack-cors
#
# This configuration allows your Rails application to handle CORS requests,
# which is essential for API endpoints accessed by frontend applications
# running on different domains.

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Origins that are allowed to make cross-origin requests
    # In production, restrict this to your actual frontend domains
    origins ENV.fetch("CORS_ALLOWED_ORIGINS", "http://localhost:3000").split(",").map(&:strip)

    resource "*",
      headers: :any,
      methods: %i[get post put patch delete options head],
      credentials: true,
      max_age: 86400, # Cache preflight request for 1 day
      expose: %w[Authorization X-Request-Id X-Runtime]
  end

  # Example: Allow all origins for public API endpoints (use with caution)
  # allow do
  #   origins "*"
  #   resource "/api/public/*",
  #     headers: :any,
  #     methods: %i[get options head],
  #     max_age: 600
  # end

  # Example: Allow specific origins for specific resources
  # allow do
  #   origins "https://trusted-partner.example.com"
  #   resource "/api/partner/*",
  #     headers: :any,
  #     methods: %i[get post put patch delete options head],
  #     credentials: true,
  #     max_age: 86400
  # end
end
