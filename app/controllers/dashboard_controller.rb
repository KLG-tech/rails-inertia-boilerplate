# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    render inertia: "Dashboard/Index"
  end
end
