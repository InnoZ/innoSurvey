class TopicsController < ApplicationController
  def ident
    @topic = Topic.find(params[:id])
    @topic_json = @topic.to_json
    respond_to do |format|
      format.html
      format.json { render json: @topic_json.to_json, status: 200 }
    end
  end
end
