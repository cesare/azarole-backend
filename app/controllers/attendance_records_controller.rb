class AttendanceRecordsController < ApplicationController
  include AuthenticationWithSession

  def index
    workplace = current_user.workplaces.find(params[:workplace_id])
    attendance_records = workplace.attendance_records.where(recorded_at: indexing_range).order(:recorded_at).all

    response_json = {
      year: target_month.year,
      month: target_month.month,
      attendanceRecords: attendance_records.map do |attendance_record|
        {
          id: attendance_record.id,
          recordedAt: attendance_record.recorded_at.iso8601,
          event: attendance_record.event
        }
      end
    }
    render json: response_json
  end

  def destroy
    workplace = current_user.workplaces.find(params[:workplace_id])
    attendance_record = workplace.attendance_records.find(params[:id])
    attendance_record.destroy!

    head :ok
  end

  private

  def indexing_range = target_month.then { (it...it.next_month) }

  def target_month
    if params[:year].present? && params[:month].present?
      return Time.zone.local(params[:year], params[:month])
    end

    if params[:month].present?
      return Time.zone.local(Time.current.year, params[:month])
    end

    Time.current.beginning_of_month
  end
end
