# frozen_string_literal: true

# Lograge configuration for structured JSON logging
# https://github.com/roidrage/lograge
#
# Lograge replaces the default Rails logging with a single-line, structured format
# that is much easier to parse and analyze in production log aggregation tools.

Rails.application.configure do
  # Enable Lograge only in production by default
  # Set LOGRAGE_ENABLED=true to enable in other environments
  config.lograge.enabled = Rails.env.production? || ENV["LOGRAGE_ENABLED"] == "true"

  # Use JSON format for structured logging
  # This makes it easy to parse logs with tools like Datadog, Splunk, ELK, etc.
  config.lograge.formatter = Lograge::Formatters::Json.new

  # Include additional request information in each log entry
  config.lograge.custom_options = lambda do |event|
    {
      # Request identification
      request_id: event.payload[:request_id],
      host: event.payload[:host],

      # User information (if authenticated)
      user_id: event.payload[:user_id],

      # Performance metrics
      allocations: event.allocations,
      db_runtime: event.payload[:db_runtime]&.round(2),
      view_runtime: event.payload[:view_runtime]&.round(2),

      # Timestamp in ISO 8601 format
      time: Time.current.iso8601,

      # Remote IP (useful for debugging and security)
      remote_ip: event.payload[:remote_ip],

      # User agent (useful for debugging client-specific issues)
      user_agent: event.payload[:user_agent],

      # Exception information (if any)
      exception: event.payload[:exception]&.first,
      exception_message: event.payload[:exception]&.second
    }.compact
  end

  # Include these payload keys in the log output
  config.lograge.custom_payload do |controller|
    {
      host: controller.request.host,
      remote_ip: controller.request.remote_ip,
      user_agent: controller.request.user_agent,
      user_id: controller.try(:current_user)&.id,
      request_id: controller.request.request_id
    }
  end

  # Keep original Rails logs for ActionCable and other non-controller actions
  config.lograge.ignore_actions = [
    "ActionCable::Connection#connect",
    "ActionCable::Connection#disconnect"
  ]

  # Ignore certain paths (like health checks) to reduce log noise
  config.lograge.ignore_custom = lambda do |event|
    # Ignore health check endpoints
    event.payload[:path] == "/up" ||
    event.payload[:path] == "/health" ||
    event.payload[:path] == "/healthz"
  end
end
