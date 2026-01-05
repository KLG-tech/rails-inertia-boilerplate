# frozen_string_literal: true

class HomeController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    render inertia: "Home", props: {
      message: "Welcome to Rails with Vue 3 and Inertia.js!"
    }
  end
end
