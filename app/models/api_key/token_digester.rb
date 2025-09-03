class ApiKey::TokenDigester
  private attr_reader :token

  def initialize(token:)
    @token = token
  end

  def digest
    OpenSSL::HMAC.hexdigest("SHA256", secret_key, token)
  end

  private

  def secret_key = "fed0f073876b71b4c2b1df09290ac2e797bbb8262d25aebc452deb0690b34f35" # temporary value
end
