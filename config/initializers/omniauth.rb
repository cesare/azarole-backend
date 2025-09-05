Rails.application.config.middleware.use OmniAuth::Builder do
  google_client_id = Rails.application.credentials.google_auth.client_id
  google_client_secret = Rails.application.credentials.google_auth.client_secret

  provider :google_oauth2, google_client_id, google_client_secret
end
OmniAuth.config.allowed_request_methods = %i[get]
