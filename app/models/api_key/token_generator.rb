class ApiKey::TokenGenerator
  def generate
    SecureRandom.base64(96)
  end
end
