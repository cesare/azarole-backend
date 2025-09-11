class ApiKeysController < ApplicationController
  include AuthenticationWithSession

  def index
    api_keys = current_user.api_keys.order(created_at: :desc).all

    response_json = {
      api_keys: api_keys.map do |api_key|
        {
          id: api_key.id,
          name: api_key.name
        }
      end
    }
    render json: response_json
  end

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

  def destroy
    api_key = current_user.api_keys.find(params[:id])
    api_key.destroy!

    head :ok
  end
end
