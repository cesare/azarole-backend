require "rails_helper"

RSpec.describe "sessions", type: :request do
  describe "DELETE /sessions" do
    let(:user) { User.create! }

    before { login_as(user:) }

    it "signs out" do
      delete "/signout"

      expect(request).to redirect_to("/")
      expect(session.to_hash.except("session_id")).to be_empty
    end
  end
end
