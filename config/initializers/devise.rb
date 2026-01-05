# frozen_string_literal: true

# Devise configuration
# https://github.com/heartcombo/devise

Devise.setup do |config|
  # ==> Mailer Configuration
  config.mailer_sender = "please-change-me-at-config-initializers-devise@example.com"

  # ==> ORM configuration
  require "devise/orm/active_record"

  # ==> Configuration for any authentication mechanism
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]

  # ==> Configuration for :database_authenticatable
  config.skip_session_storage = [ :http_auth ]

  # ==> Configuration for :validatable
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> Configuration for :timeoutable
  # config.timeout_in = 30.minutes

  # ==> Configuration for :lockable
  # config.lock_strategy = :failed_attempts
  # config.unlock_keys = [ :email ]
  # config.unlock_strategy = :both
  # config.maximum_attempts = 20
  # config.unlock_in = 1.hour
  # config.last_attempt_warning = true

  # ==> Configuration for :recoverable
  config.reset_password_within = 6.hours

  # ==> Configuration for :confirmable
  # config.allow_unconfirmed_access_for = 2.days
  # config.confirm_within = 3.days
  # config.reconfirmable = true

  # ==> Configuration for :rememberable
  # config.remember_for = 2.weeks
  # config.extend_remember_period = false
  # config.rememberable_options = {}

  # ==> Navigation configuration
  config.sign_out_via = :delete

  # ==> OmniAuth configuration
  # Configure Keycloak OAuth provider
  if ENV["KEYCLOAK_CLIENT_ID"].present?
    config.omniauth :keycloak,
      ENV.fetch("KEYCLOAK_CLIENT_ID"),
      ENV.fetch("KEYCLOAK_CLIENT_SECRET"),
      client_options: {
        site: ENV.fetch("KEYCLOAK_SITE_URL"),
        realm: ENV.fetch("KEYCLOAK_REALM")
      },
      name: "keycloak",
      strategy_class: OmniAuth::Strategies::KeycloakOpenId
  end

  # ==> Warden configuration
  # config.warden do |manager|
  #   manager.intercept_401 = false
  #   manager.default_strategies(scope: :user).unshift :some_external_strategy
  # end

  # ==> Turbo compatibility
  # When using Devise with Hotwire/Turbo, configure the responder
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  # ==> Scopes configuration
  # config.scoped_views = false
  # config.default_scope = :user

  # ==> Sign out configuration
  # config.sign_out_all_scopes = true

  # ==> Paranoid mode
  # Don't reveal whether a user exists on password reset/unlock
  config.paranoid = true
end
