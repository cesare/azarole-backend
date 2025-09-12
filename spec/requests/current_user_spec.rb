require "rails_helper"

RSpec.describe "current_user", type: :request do
  describe "GET /current_user" do
    context "when user has not signed in" do
      it "returns unauthorized error" do
        get "/current_user"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user has signed in" do
      let(:user) { User.create! }

      before { login_as(user:) }

      it "returns user's attributes" do
        get "/current_user"

        expect(response).to have_http_status(:ok)

        expected_json = {
          user_id: user.id
        }.to_json
        expect(response.body).to be_json_eql(expected_json)
      end
    end
  end
end
