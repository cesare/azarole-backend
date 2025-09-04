require "rails_helper"

RSpec.describe "POST /api/workplaces/:id/clock_ins", type: :request do
  context "when API key is not given" do
    it "results error" do
      post "/api/workplaces/1/clock_ins"

      expect(response).to be_unauthorized
    end
  end

  context "when API key is given" do
    let(:user) { User.create! }
    let(:workplace) { user.workplaces.create!(name: "Home") }
    let(:api_key) do
      ApiKey::NewKeyRegistrar.new(user:, name: "testing").register.raw_token
    end

    let(:request_headers) do
      {
        "Authorization" => "Bearer #{api_key}"
      }
    end

    it "creates clock-in record" do
      expect {
        post "/api/workplaces/#{workplace.id}/clock_ins", headers: request_headers
      }.to change { workplace.attendance_records.count }.by(1)

      expect(response).to be_created

      attendance_record = workplace.attendance_records.last
      expect(attendance_record.event).to eq "clock-in"
    end
  end
end
