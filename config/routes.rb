Rails.application.routes.draw do
  get "auth/google_oauth2/callback", to: "google_auth_sessions#create"
  get "auth/failure", to: redirect("/")
  get "current_user", to: "current_user#show"
  delete "signout", to: "sessions#destroy"

  resources :api_keys, only: %i[index create destroy]
  resources :workplaces, only: %i[index create] do
    resources :attendance_records, only: %i[index destroy]

    get "monthly_attendances/:year/:month", to: "monthly_attendances#show"
  end

  namespace :api do
    resources :workplaces, only: %i[] do
      resources :clock_ins, only: %i[create]
      resources :clock_outs, only: %i[create]
    end
  end
end
