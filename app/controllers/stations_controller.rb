class StationsController < ApplicationController
  before_action :authenticate

  def content
    @station = Station.find(params[:id])
  end
end
