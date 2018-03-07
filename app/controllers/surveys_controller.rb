class SurveysController < ApplicationController
  def index
    @surveys = Survey.all
  end

  def ident
    @survey = Survey.find(params[:id])
    @topics = @survey.topics.all.map { |t| t.to_json }
  end
end
