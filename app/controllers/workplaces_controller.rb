class WorkplacesController < ApplicationController
  include AuthenticationWithSession

  def index
    workplaces = current_user.workplaces.order(:id).all

    response_json = {
      workplaces: workplaces.map { |workplace| workplace_json(workplace) }
    }
    render json: response_json
  end

  def create
    workplace = current_user.workplaces.create!(name: params[:name])

    response_json = {
      workplace: workplace_json(workplace)
    }
    render json: response_json, status: :created
  end

  private

  def workplace_json(workplace) = {
    id: workplace.id,
    name: workplace.name
  }
end
