class Api::ClockInsController < ApplicationController
  def create
    render json: {}, status: :created
  end
end
