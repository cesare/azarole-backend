Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  get "auth/google_oauth2/callback", to: "google_auth_sessions#create"
  get "auth/failure", to: redirect("/")
  delete "signout", to: "sessions#destroy"

  resources :workplaces, only: %i[index create]

  namespace :api do
    resources :workplaces, only: %i[] do
      resources :clock_ins, only: %i[create]
      resources :clock_outs, only: %i[create]
    end
  end
end
