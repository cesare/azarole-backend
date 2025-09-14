class MonthlyAttendancesController < ApplicationController
  include AuthenticationWithSession

  def show
    monthly_report = MonthlyReportGenerator.new(year:, month:).generate

    render json: monthly_report.to_hash
  end

  private

  def year = params[:year]

  def month = params[:month]
end
