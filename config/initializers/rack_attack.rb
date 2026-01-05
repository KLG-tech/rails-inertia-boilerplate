# frozen_string_literal: true

# Rack::Attack configuration for rate limiting and request filtering
# https://github.com/rack/rack-attack

class Rack::Attack
  # Cache store for tracking request counts
  # Uses Rails.cache by default, but you can configure a separate store
  # Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # ----------------------------------------------------------------------------
  # Safelists
  # ----------------------------------------------------------------------------

  # Allow all requests from localhost (useful for development)
  safelist("allow-localhost") do |req|
    req.ip == "127.0.0.1" || req.ip == "::1"
  end

  # Allow requests from trusted internal IPs (e.g., health checks, load balancers)
  # safelist("allow-internal") do |req|
  #   ENV["TRUSTED_IPS"].to_s.split(",").include?(req.ip)
  # end

  # ----------------------------------------------------------------------------
  # Blocklists
  # ----------------------------------------------------------------------------

  # Block requests from specific IPs (loaded from environment variable)
  blocklist("block-bad-ips") do |req|
    ENV["BLOCKED_IPS"].to_s.split(",").include?(req.ip)
  end

  # Block requests with suspicious paths (common attack vectors)
  blocklist("block-suspicious-paths") do |req|
    suspicious_paths = %w[
      /wp-admin
      /wp-login.php
      /xmlrpc.php
      /.env
      /phpinfo.php
      /phpmyadmin
    ]
    suspicious_paths.any? { |path| req.path.downcase.start_with?(path) }
  end

  # ----------------------------------------------------------------------------
  # Throttles
  # ----------------------------------------------------------------------------

  # General rate limiting: 300 requests per 5 minutes per IP
  throttle("req/ip", limit: 300, period: 5.minutes) do |req|
    req.ip unless req.path.start_with?("/assets", "/vite")
  end

  # Limit login attempts: 5 requests per 20 seconds per IP
  throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
    if req.path == "/users/sign_in" && req.post?
      req.ip
    end
  end

  # Limit login attempts by email: 5 requests per 20 seconds per email
  throttle("logins/email", limit: 5, period: 20.seconds) do |req|
    if req.path == "/users/sign_in" && req.post?
      # Normalize email to prevent case-sensitivity bypass
      req.params.dig("user", "email").to_s.downcase.gsub(/\s+/, "").presence
    end
  end

  # Limit password reset requests: 5 per hour per email
  throttle("password_resets/email", limit: 5, period: 1.hour) do |req|
    if req.path == "/users/password" && req.post?
      req.params.dig("user", "email").to_s.downcase.gsub(/\s+/, "").presence
    end
  end

  # Limit account creation: 3 per hour per IP
  throttle("signups/ip", limit: 3, period: 1.hour) do |req|
    if req.path == "/users" && req.post?
      req.ip
    end
  end

  # API rate limiting (if you have API endpoints)
  throttle("api/ip", limit: 100, period: 1.minute) do |req|
    req.ip if req.path.start_with?("/api/")
  end

  # ----------------------------------------------------------------------------
  # Exponential Backoff for Repeated Offenders
  # ----------------------------------------------------------------------------

  # Exponential backoff for repeated login failures
  # After 100 failed login attempts, block for 1 day
  blocklist("fail2ban/login") do |req|
    Rack::Attack::Fail2Ban.filter("login-#{req.ip}", maxretry: 100, findtime: 1.day, bantime: 1.day) do
      req.path == "/users/sign_in" && req.post?
    end
  end

  # ----------------------------------------------------------------------------
  # Custom Response
  # ----------------------------------------------------------------------------

  # Customize throttle response
  self.throttled_responder = lambda do |env|
    retry_after = (env["rack.attack.match_data"] || {})[:period]
    [
      429,
      {
        "Content-Type" => "application/json",
        "Retry-After" => retry_after.to_s
      },
      [ { error: "Rate limit exceeded. Retry later." }.to_json ]
    ]
  end

  # Customize blocklist response
  self.blocklisted_responder = lambda do |env|
    [
      403,
      { "Content-Type" => "application/json" },
      [ { error: "Forbidden" }.to_json ]
    ]
  end
end

# Enable Rack::Attack
Rails.application.config.middleware.use Rack::Attack

# Log throttled and blocked requests in production
ActiveSupport::Notifications.subscribe("throttle.rack_attack") do |_name, _start, _finish, _request_id, payload|
  req = payload[:request]
  Rails.logger.warn(
    "[Rack::Attack] Throttled #{req.ip} for #{req.path} (matched: #{payload[:match_discriminator]})"
  )
end

ActiveSupport::Notifications.subscribe("blocklist.rack_attack") do |_name, _start, _finish, _request_id, payload|
  req = payload[:request]
  Rails.logger.warn("[Rack::Attack] Blocked #{req.ip} for #{req.path}")
end
