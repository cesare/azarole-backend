class Api::ClockInsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate_with_api_key!

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

  private

  def authenticate_with_api_key!
    authenticate_or_request_with_http_token do |token, _options|
      digest = ApiKey::TokenDigester.new(token:).digest
      @api_key = ApiKey.includes(:user).find_by!(digest:)
    end
  end

  def current_user = @api_key.user
end
