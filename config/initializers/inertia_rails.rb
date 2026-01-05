# frozen_string_literal: true

InertiaRails.configure do |config|
  # Set the default component path prefix
  # config.component_path_resolver = ->(path:, action:) { "#{path}/#{action.camelize(:lower)}" }

  # Set the default root view (the layout that will be used for Inertia responses)
  config.default_render = true

  # SSR configuration (optional, for server-side rendering)
  # config.ssr_enabled = false
  # config.ssr_url = 'http://localhost:13714'
end
