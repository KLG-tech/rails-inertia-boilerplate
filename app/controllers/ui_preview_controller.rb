# frozen_string_literal: true

class UiPreviewController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    render inertia: "UiPreview/Index"
  end
end
