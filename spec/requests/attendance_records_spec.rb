require "rails_helper"

RSpec.describe "attendance_records", type: :request do
  describe "GET /workplaces/:workplace_id/attendance_records" do
    context "when user is not signed in" do
      it "returns unauthorized error" do
        get "/workplaces/123/attendance_records"

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
        get "/workplaces/#{workplace.id}/attendance_records", params: {year:, month:}

        expect(response).to have_http_status(:ok)

        expected_json = {
          attendanceRecords: [
            {event: "clock-in", recordedAt: yesterday.change(hour: 11).iso8601},
            {event: "clock-out", recordedAt: yesterday.change(hour: 13).iso8601},
            {event: "clock-in", recordedAt: today.change(hour: 10).iso8601}
          ]
        }.to_json
        expect(response.body).to be_json_eql(expected_json)
      end
    end

    context "when signed-in does not have attendance record for the month" do
      let(:user) { User.create! }
      let(:workplace) { user.workplaces.create!(name: "Home") }

      let(:today) { Time.current.beginning_of_day }
      let(:last_month_day) { today.last_month }

      let(:year) { today.year.to_s }
      let(:month) { format "%02d", today.month }

      before do
        login_as(user:)

        workplace.attendance_records.create!(event: "clock-in", recorded_at: last_month_day.change(hour: 13))
        workplace.attendance_records.create!(event: "clock-out", recorded_at: last_month_day.change(hour: 17))
      end

      it "returns empty records" do
        get "/workplaces/#{workplace.id}/attendance_records", params: {year:, month:}

        expect(response).to have_http_status(:ok)

        expected_json = {
          attendanceRecords: []
        }.to_json
        expect(response.body).to be_json_eql(expected_json)
      end
    end
  end

  describe "DELETE /workplaces/:workplace_id/attendance_records/:id" do
    context "when user has not signed in" do
      it "returns unauthorized error" do
        delete "/workplaces/123/attendance_records/234"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user has signed in" do
      let(:user) { User.create! }
      let(:workplace) { user.workplaces.create!(name: "Home") }
      let!(:attendance_record) { workplace.attendance_records.create!(recorded_at: Time.current.yesterday, event: "clock-in") }

      before { login_as(user:) }

      it "deletes the record" do
        expect {
          delete "/workplaces/#{workplace.id}/attendance_records/#{attendance_record.id}"
        }.to change { workplace.attendance_records.count }.by(-1)

        expect(response).to have_http_status(:ok)
        expect(workplace.attendance_records.find_by(id: attendance_record.id)).to be_blank
      end
    end
  end
end
