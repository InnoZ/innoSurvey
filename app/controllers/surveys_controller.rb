class SurveysController < ApplicationController
  def index
    @surveys = Survey.all
  end

  def show
    @survey = Survey.find(params[:id])
    respond_to do |format|
      format.html
      format.csv do 
        begin
          send_data @survey.csv, filename: "csv_innoSurvey_#{@survey.name}-#{Date.today}.csv" 
        rescue StandardError => e
          render json: {
            error: e.to_s  
          }, status: :not_found
        end
      end
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
