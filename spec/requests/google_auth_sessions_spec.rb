require "rails_helper"

RSpec.describe "google_auth_sessions", type: :request do
  describe "GET /auth/google/callback" do
    context "when user is not present" do
      let(:uid) { SecureRandom.base64(24) }

      before do
        OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({uid:})
      end

      it "registers user" do
        expect {
          get "/auth/google/callback"
        }.to change(User, :count).by(1)
          .and(change(GoogleAuthenticatedUser, :count).by(1))

        expect(response).to redirect_to("/")

        google_authenticated_user = GoogleAuthenticatedUser.find_by(uid: uid)
        expect(google_authenticated_user).to be_present

        user = google_authenticated_user.user
        expect(user).to be_present

        expect(session[:user_id]).to eq user.id
      end
    end

    context "when user is present" do
      let(:user) { User.create! }
      let(:uid) { SecureRandom.base64(24) }
      let!(:google_authenticated_user) { GoogleAuthenticatedUser.create!(user:, uid:) }

      before do
        OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({uid:})
      end

      it "signs in as the user" do
        expect {
          get "/auth/google/callback"
        }.to not_change(User, :count)
          .and(not_change(GoogleAuthenticatedUser, :count))

        expect(response).to redirect_to("/")
        expect(session[:user_id]).to eq user.id
      end
    end
  end
end
