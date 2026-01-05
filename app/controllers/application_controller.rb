class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Pundit: ensure authorization is called on all controller actions
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Inertia shared data - available to all pages
  inertia_share do
    {
      currentUser: current_user&.then { |user|
        {
          id: user.id,
          email: user.email,
          name: user.name
        }
      },
      flash: {
        notice: flash[:notice],
        alert: flash[:alert]
      }
    }
  end

  private

  # Redirect to dashboard after successful login
  def after_sign_in_path_for(_resource)
    dashboard_path
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end

  def skip_pundit?
    devise_controller? || active_admin_controller?
  end

  def devise_controller?
    is_a?(::DeviseController) if defined?(::DeviseController)
  end

  def active_admin_controller?
    is_a?(::ActiveAdmin::BaseController) if defined?(::ActiveAdmin)
  end
end
