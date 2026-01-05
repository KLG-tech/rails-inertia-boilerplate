# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # Handle Keycloak OAuth callback
    def keycloak
      @user = User.find_or_create_from_omniauth(request.env["omniauth.auth"])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: "Keycloak") if is_navigational_format?
      else
        session["devise.keycloak_data"] = request.env["omniauth.auth"].except(:extra)
        redirect_to new_user_registration_url
      end
    end

    # Handle OAuth failures
    def failure
      redirect_to root_path, alert: "Authentication failed: #{failure_message}"
    end

    private

    def failure_message
      exception = request.env["omniauth.error"]
      error = request.env["omniauth.error.type"]

      if exception
        exception.message
      elsif error
        error.to_s.humanize
      else
        "Unknown error"
      end
    end
  end
end
