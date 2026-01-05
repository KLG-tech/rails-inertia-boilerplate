Rails.application.routes.draw do
  # Devise authentication routes with OmniAuth callbacks
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions"
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Dashboard (authenticated users)
  get "dashboard", to: "dashboard#index"

  # Users management
  resources :users

  # UI Kit Preview (development only)
  get "ui", to: "ui_preview#index"

  # Development-only routes
  if Rails.env.development?
    get "godmode", to: "dev/sessions#godmode"
  end

  # Defines the root path route ("/")
  root "home#index"
end
