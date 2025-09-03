module AuthenticationWithApiKey
  extend ActiveSupport::Concern

  include ActionController::HttpAuthentication::Token::ControllerMethods

  included do
    before_action :authenticate_with_api_key!
  end

  private

  def authenticate_with_api_key!
    authenticate_or_request_with_http_token do |token, _options|
      digest = ApiKey::TokenDigester.new(token:).digest
      @api_key = ApiKey.includes(:user).find_by!(digest:)
    end
  end

  def current_user = @api_key.user
end
