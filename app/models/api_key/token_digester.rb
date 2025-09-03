class ApiKey::TokenDigester
  private attr_reader :token

  def initialize(token:)
    @token = token
  end

  def digest
    OpenSSL::HMAC.hexdigest("SHA256", secret_key, token)
  end

  private

  def secret_key = Rails.application.credentials.api_key.digesting_secret_key
end
