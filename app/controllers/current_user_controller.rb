class CurrentUserController < ApplicationController
  include AuthenticationWithSession

  def show
    response_json = {user_id: current_user.id}
    render json: response_json
  end
end
