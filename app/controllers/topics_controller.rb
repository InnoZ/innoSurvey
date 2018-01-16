class TopicsController < ApplicationController
  before_action :set_survey, :set_station

  def show
    @topic = @station.topics.find_by(id: params[:id])

    respond_to do |format|
      format.json { render json: @topic.to_json, status: 200 }
    end
  end

  private

  def set_survey
    @survey = Survey.find_by(name_url_safe: params[:survey_name])
  end

  def set_station
    @station = @survey.stations.find_by(id: params[:station_id])
  end
end
