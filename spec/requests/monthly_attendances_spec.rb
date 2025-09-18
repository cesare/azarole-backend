require "rails_helper"

RSpec.describe "monthly_attendances", type: :request do
  describe "GET /workplaces/:workplace_id/monthly_attendances/:year/:month" do
    context "when user has not signed in" do
      it "returns unauthorized error" do
        get "/workplaces/123/monthly_attendances/2025/09"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user has signed in" do
      let(:user) { User.create! }
      let(:workplace) { user.workplaces.create!(name: "Home") }

      before do
        workplace.attendance_records.create!(event: "clock-in", recorded_at: Time.zone.parse("2025-09-01 12:34:56"))
        workplace.attendance_records.create!(event: "clock-out", recorded_at: Time.zone.parse("2025-09-01 17:00:00"))

        workplace.attendance_records.create!(event: "clock-in", recorded_at: Time.zone.parse("2025-09-02 15:01:02"))

        workplace.attendance_records.create!(event: "clock-in", recorded_at: Time.zone.parse("2025-09-30 10:20:30"))
        workplace.attendance_records.create!(event: "clock-out", recorded_at: Time.zone.parse("2025-09-30 12:12:12"))
        workplace.attendance_records.create!(event: "clock-in", recorded_at: Time.zone.parse("2025-09-30 13:14:15"))
        workplace.attendance_records.create!(event: "clock-out", recorded_at: Time.zone.parse("2025-09-30 18:11:22"))

        login_as(user:)
      end

      it "returns aggregated attendances of the year/month" do
        get "/workplaces/#{workplace.id}/monthly_attendances/2025/09"

        expect(response).to have_http_status(:ok)

        expected_json = {
          year: 2025,
          month: 9,
          dailyWorkingTimes: [
            {
              day: 1,
              timeTracked: 15904,
              hasError: false,
              workingTimes: [
                {
                  complete: true,
                  startedAt: "2025-09-01T12:34:56+09:00",
                  endedAt: "2025-09-01T17:00:00+09:00",
                  timeTracked: 15904 # = 17:00:00 - 12:34:56
                }
              ]
            },
            {
              day: 2,
              timeTracked: 0,
              hasError: true,
              workingTimes: [
                {
                  complete: false,
                  startedAt: "2025-09-02T15:01:02+09:00",
                  endedAt: nil,
                  timeTracked: 0
                }
              ]
            },
            {day: 3, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 4, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 5, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 6, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 7, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 8, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 9, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 10, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 11, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 12, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 13, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 14, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 15, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 16, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 17, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 18, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 19, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 20, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 21, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 22, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 23, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 24, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 25, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 26, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 27, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 28, timeTracked: 0, hasError: false, workingTimes: []},
            {day: 29, timeTracked: 0, hasError: false, workingTimes: []},
            {
              day: 30,
              timeTracked: 24529,
              hasError: false,
              workingTimes: [
                {
                  complete: true,
                  startedAt: "2025-09-30T10:20:30+09:00",
                  endedAt: "2025-09-30T12:12:12+09:00",
                  timeTracked: 6702 # = 12:12:12 - 10:20:30
                },
                {
                  complete: true,
                  startedAt: "2025-09-30T13:14:15+09:00",
                  endedAt: "2025-09-30T18:11:22+09:00",
                  timeTracked: 17827 # = 18:11:22 - 13:14:15
                }
              ]
            }
          ]
        }.to_json
        expect(response.body).to be_json_eql(expected_json)
      end
    end
  end
end
