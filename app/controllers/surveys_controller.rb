class SurveysController < ApplicationController
  def index
    @surveys = Survey.all
  end

  def show
    @survey = Survey.find(params[:id])
    respond_to do |format|
      format.html
      format.csv { send_data '1,2,3,4,4', filename: "userinfo-#{Date.today}.csv" }
    end
  end

  def ident
    @survey = Survey.find(params[:id])
    @stations = @survey.stations.all.map do |s|
      {
        id: s.id,
        name: s.name,
        topics: s.topics.map(&:to_json)
      }
    end
  end
end
