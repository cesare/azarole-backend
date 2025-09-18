class MonthlyAttendancesController < ApplicationController
  include AuthenticationWithSession

  def show
    workplace = current_user.workplaces.find(params[:workplace_id])
    year = params[:year].to_i(10)
    month = params[:month].to_i(10)
    working_times = MonthlyReportGenerator.new(workplace:, year:, month:).generate
    monthly_working_times = MonthlyWorkingTime.new(year:, month:, working_times:)

    response_json = {
      year: year,
      month: month,
      dailyWorkingTimes: monthly_working_times.map do |date, daily_working_times|
        {
          day: date.day,
          timeTracked: daily_working_times.time_tracked,
          hasError: daily_working_times.has_error?,
          workingTimes: daily_working_times.map do |working_time|
            {
              complete: working_time.complete?,
              startedAt: working_time.started_at&.iso8601,
              endedAt: working_time.ended_at&.iso8601,
              timeTracked: working_time.duration.round
            }
          end
        }
      end
    }
    render json: response_json
  end
end
