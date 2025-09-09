require "rails_helper"

RSpec.describe "attendance_records", type: :request do
  describe "GET /workplaces/:workplace_id/attendance_records" do
    context "when user is not signed in" do
      it "returns unauthorized error" do
        get "/workplaces/123/attendance_records/2025/09"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is signed in" do
      let(:user) { User.create! }
      let(:workplace) { user.workplaces.create!(name: "Home") }

      let(:today) { Time.current.beginning_of_day }
      let(:yesterday) { today.yesterday }
      let(:last_month_day) { today.last_month }

      let(:year) { today.year.to_s }
      let(:month) { format "%02d", today.month }

      before do
        login_as(user:)

        workplace.attendance_records.create!(event: "clock-in", recorded_at: today.change(hour: 10))

        workplace.attendance_records.create!(event: "clock-in", recorded_at: yesterday.change(hour: 11))
        workplace.attendance_records.create!(event: "clock-out", recorded_at: yesterday.change(hour: 13))

        workplace.attendance_records.create!(event: "clock-in", recorded_at: last_month_day.change(hour: 13))
        workplace.attendance_records.create!(event: "clock-out", recorded_at: last_month_day.change(hour: 17))
      end

      it "lists attendance_records of specified month" do
        get "/workplaces/#{workplace.id}/attendance_records/#{year}/#{month}"

        expect(response).to have_http_status(:ok)

        expected_json = {
          attendance_records: [
            {event: "clock-in", recordedAt: yesterday.change(hour: 11).iso8601},
            {event: "clock-out", recordedAt: yesterday.change(hour: 13).iso8601},
            {event: "clock-in", recordedAt: today.change(hour: 10).iso8601}
          ]
        }.to_json
        expect(response.body).to be_json_eql(expected_json)
      end
    end
  end
end
