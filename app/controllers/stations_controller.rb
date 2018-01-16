class StationsController < ApplicationController
  before_action :get_survey, :get_station

  def show
    respond_to do |format|
      format.json { render json: @station.to_json, status: 200 }
    end
  end

  private

  def get_survey
    @survey = Survey.find_by(name_url_safe: params[:survey_name])
  end

  def get_station
    @station = @survey.stations.find_by(id: params[:id])
  end
end
