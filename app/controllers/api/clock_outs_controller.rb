class Api::ClockOutsController < ApplicationController
  def create
    workplace = Workplace.find(params[:workplace_id])
    attendance_record = AttendanceRecord.create!(workplace:, event: "clock-out")

    response_json = {
      attendance_record: {
        id: attendance_record.id,
        recorded_at: attendance_record.recorded_at
      }
    }
    render json: response_json, status: :created
  end
end
