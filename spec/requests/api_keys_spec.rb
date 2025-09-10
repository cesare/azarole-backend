require "rails_helper"

RSpec.describe "api_keys", type: :request do
  describe "POST /api_keys" do
    context "when user has not signed in" do
      it "returns unauthorized error" do
        post "/api_keys", params: {name: "test"}

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user has signed in" do
      let(:user) { User.create! }

      before { login_as(user:) }

      it "creates new API key" do
        expect {
          post "/api_keys", params: {name: "for testing"}
        }.to change { user.api_keys.count }.by(1)

        expect(response).to be_created

        response_api_key_node = JSON.parse(response.body)["api_key"]

        api_key_id = response_api_key_node["id"]
        registered_api_key = user.api_keys.find_by(id: api_key_id)
        expect(registered_api_key).to be_present

        expect(response_api_key_node["name"]).to eq registered_api_key.name

        token = response_api_key_node["token"]
        expect(token).to be_present
        expect(token).not_to eq registered_api_key.digest
      end
    end
  end
end
