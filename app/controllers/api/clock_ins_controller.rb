class Api::ClockInsController < ApplicationController
  include AuthenticationWithApiKey

  def create
    workplace = current_user.workplaces.find(params[:workplace_id])
    attendance_record = workplace.attendance_records.create!(event: "clock-in")

    response_json = {
      attendance_record: {
        id: attendance_record.id,
        recorded_at: attendance_record.recorded_at
      }
    }
    render json: response_json, status: :created
  end
end
