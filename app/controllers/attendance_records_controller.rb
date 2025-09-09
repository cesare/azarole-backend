class AttendanceRecordsController < ApplicationController
  include AuthenticationWithSession

  def index
    workplace = current_user.workplaces.find_by!(params[:workplace_id])
    attendance_records = workplace.attendance_records.where(recorded_at: indexing_range).order(:recorded_at).all

    response_json = {
      attendance_records: attendance_records.map do |attendance_record|
        {
          id: attendance_record.id,
          recordedAt: attendance_record.recorded_at.iso8601,
          event: attendance_record.event
        }
      end
    }
    render json: response_json
  end

  private

  def indexing_range = beginning_of_specified_month.then { (it...it.next_month) }

  def beginning_of_specified_month = Time.zone.local(params[:year], params[:month])
end
