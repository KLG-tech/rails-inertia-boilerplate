# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    skip_after_action :verify_authorized, raise: false
    skip_after_action :verify_policy_scoped, raise: false

    # GET /users/sign_in
    def new
      render inertia: "Auth/Login", props: {
        flash: {
          alert: flash[:alert],
          notice: flash[:notice]
        }
      }
    end

    # DELETE /users/sign_out
    def destroy
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      set_flash_message! :notice, :signed_out if signed_out
      redirect_to root_path
    end
  end
end
