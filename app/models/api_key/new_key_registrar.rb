class ApiKey::NewKeyRegistrar
  private attr_reader :user, :name

  def initialize(user:, name:)
    @user = user
    @name = name
  end

  def register
    token = ApiKey::TokenGenerator.new.generate
    digest = ApiKey::TokenDigester.new(token:).digest
    api_key = ApiKey.create!(user:, name:, digest:)

    RegisteredKey.new(api_key:, raw_token: token)
  end

  RegisteredKey = Struct.new(:api_key, :raw_token)
end
