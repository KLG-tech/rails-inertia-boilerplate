# frozen_string_literal: true

module Dev
  class SessionsController < ApplicationController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    # GET /godmode - Sign in as first user (development only)
    def godmode
      unless Rails.env.development?
        redirect_to root_path, alert: "Not available in production"
        return
      end

      user = User.first

      if user.nil?
        # Create a default admin user if none exists
        user = User.create!(
          email: "admin@example.com",
          name: "Admin User",
          password: SecureRandom.hex(12)
        )
        user.add_role(:admin)
      end

      sign_in(user)
      redirect_to dashboard_path, notice: "Signed in as #{user.email} (God Mode)"
    end
  end
end
