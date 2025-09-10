class ApiKeysController < ApplicationController
  include AuthenticationWithSession

  def create
    registered_key = ApiKey::NewKeyRegistrar.new(user: current_user, name: params[:name]).register

    response_json = {
      api_key: {
        id: registered_key.api_key.id,
        name: registered_key.api_key.name,
        token: registered_key.raw_token
      }
    }
    render json: response_json, status: :created
  end
end
