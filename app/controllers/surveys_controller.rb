class SurveysController < ApplicationController
  def index
    @surveys = Survey.all
  end

  def ident
    @survey = Survey.find(params[:id])
    @stations = Survey.first.stations.all.map do |s|
      {
        id: s.id,
        name: s.name,
        topics: s.topics.map(&:to_json)
      }
    end
  end
end
