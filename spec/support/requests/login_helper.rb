module LoginHelper
  def login_as(user:)
    uid = SecureRandom.base64(24)
    GoogleAuthenticatedUser.create!(user:, uid:)
    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({uid:})

    get "/auth/google/callback"
  end
end
