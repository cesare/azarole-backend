class MonthlyAttendancesController < ApplicationController
  include AuthenticationWithSession

  def show
    workplace = current_user.workplaces.find(params[:workplace_id])
    year = params[:year].to_i(10)
    month = params[:month].to_i(10)
    work_times = MonthlyReportGenerator.new(workplace:, year:, month:).generate

    date_from = Date.new(year, month)
    date_range = (date_from..date_from.end_of_month)

    response_json = {
      year: year,
      month: month,
      dailyWorkTimes: date_range.map do |date|
        daily_work_times = DailyWorkingTime.new(date:, working_times: work_times[date] || [])

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
