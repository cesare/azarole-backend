module AuthenticationWithSession
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_with_session!
  end

  private

  def authenticate_with_session!
    user_id = session[:user_id]
    if user_id.present?
      @current_user = User.find(user_id)
    else
      head :unauthorized
    end
  end

  def current_user = @current_user
end
