class SurveysController < ApplicationController
  before_action :set_cors, only: [:roles]
  before_action :allow_iframe_request, only: [:show, :ident]

  def index
    @surveys = Survey.all
  end

  def show
    @survey = Survey.find(params[:id])
    respond_to do |format|
      format.html
      format.csv do
        if @survey.answers.any?
          send_data @survey.csv, filename: "csv_innoSurvey_#{@survey.name}-#{Date.today}.csv"
        else
          flash[:danger] = "This survey has no answers yet."
          redirect_to root_path
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

  def roles
    @survey = Survey.find(params[:id])

    return_json = {}
    @survey.roles.each { |role| return_json["#{role.id}"] = role.name }

    render json: return_json, status: 200
  end
end
