class WorkplacesController < ApplicationController
  def index
    workplaces = Workplace.all

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
end
