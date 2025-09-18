class MonthlyAttendancesController < ApplicationController
  include AuthenticationWithSession

  def show
    workplace = current_user.workplaces.find(params[:workplace_id])
    year = params[:year].to_i(10)
    month = params[:month].to_i(10)
    work_times = MonthlyReportGenerator.new(workplace:, year:, month:).generate
    monthly_working_times = MonthlyWorkingTime.new(year:, month:, working_times: work_times)

    response_json = {
      year: year,
      month: month,
      dailyWorkTimes: monthly_working_times.map do |date, daily_work_times|
        {
          day: date.day,
          timeTracked: daily_work_times.time_tracked,
          hasError: daily_work_times.has_error?,
          workTImes: daily_work_times.map do |work_time|
            {
              complete: work_time.complete?,
              startedAt: work_time.started_at&.iso8601,
              endedAt: work_time.ended_at&.iso8601,
              timeTracked: work_time.duration.round
            }
          end
        }
      end
    }
    render json: response_json
  end
end
