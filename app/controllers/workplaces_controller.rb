class WorkplacesController < ApplicationController
  include AuthenticationWithSession

  def index
    workplaces = current_user.workplaces.order(:id).all

    response_json = {
      workplaces: workplaces.map do |wp|
        {
          id: wp.id,
          name: wp.name
        }
      end
    }
    render json: response_json
  end

  def create
    workplace = current_user.workplaces.create!(name: params[:name])

    response_json = {
      workplace: {
        id: workplace.id,
        name: workplace.name
      }
    }
    render json: response_json, status: :created
  end
end
