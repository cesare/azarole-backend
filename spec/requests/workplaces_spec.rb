require "rails_helper"

RSpec.describe "workplaces", type: :request do
  describe "GET /workplaces" do
    context "when user is not signed in" do
      it "returns unauthorized error" do
        get "/workplaces"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is signed in" do
      let(:user) { User.create! }
      let!(:workplace_home) { user.workplaces.create!(name: "Home") }
      let!(:workplace_client_1) { user.workplaces.create!(name: "Client 1") }

      before { login_as(user:) }

      it "returns user's workplaces" do
        get "/workplaces"

        expect(response).to have_http_status(:ok)

        expected_json = {
          workplaces: [
            {
              id: workplace_home.id,
              name: "Home"
            },
            {
              id: workplace_client_1.id,
              name: "Client 1"
            }
          ]
        }.to_json
        expect(response.body).to be_json_eql(expected_json).including(:id)
      end
    end
  end
end
