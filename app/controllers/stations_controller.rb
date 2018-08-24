class StationsController < ApplicationController
  before_action :authenticate

  def content
    @station = Station.find(params[:id])
  end

  def create
    @survey = Survey.find(station_params[:survey_id])
    if @survey.stations.new(station_params).save
      flash[:success] = 'Saved!'
      redirect_to surveys_path
    else
      flash[:error] = 'An error occured!'
      redirect_back(fallback_location: surveys_path)
    end
  end

  def update
    @station = Station.find(params[:id])
    if @station.update_attributes(station_params)
      flash[:success] = 'Saved!'
      redirect_to surveys_path
    else
      flash[:error] = 'An error occured!'
      redirect_back(fallback_location: surveys_path)
    end
  end

  def destroy
    @station = Station.find(params[:id])
    if @station.destroy
      flash[:warning] = 'Deleted!'
      redirect_to surveys_path
    else
      flash[:error] = 'An error occured!'
      redirect_back(fallback_location: surveys_path)
    end
  end

  private

  def station_params
    params.require(:station).permit(:name, :survey_id)
  end
end
