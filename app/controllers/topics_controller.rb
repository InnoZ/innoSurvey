class TopicsController < ApplicationController
  before_action :authenticate, only: %i[new edit create update destroy]

  def ident
    @topic = Topic.find(params[:id])
    @topic_json = @topic.to_json
    respond_to do |format|
      format.html
      format.json { render json: @topic_json.to_json, status: 200 }
    end
  end

  # Ajax endpoint which returns which topics a given user(with specific role)
  # has allready fully answered
  def answered_topics_by_user
    user_answers = Answer.where(uuid: params[:uuid])
    topic_ids = user_answers.map{ |a| a.statement.topic.id }
    render json: topic_ids.uniq, status:200
  end

  def create
    @station = Station.find(params[:station_id])
    @topic = @station.topics.new(topic_params)
    if @topic.save
      flash[:success] = 'Saved!'
      redirect_to surveys_path
    else
      flash[:error] = @topic.errors
      redirect_back(fallback_location: surveys_path)
    end
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(topic_params)
      flash[:success] = 'Saved!'
      redirect_to surveys_path
    else
      flash[:error] = 'An error occured!'
      redirect_back(fallback_location: surveys_path)
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    if @topic.destroy
      flash[:warning] = 'Deleted!'
      redirect_to surveys_path
    else
      flash[:error] = 'An error occured!'
      redirect_back(fallback_location: surveys_path)
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:name, :description)
  end
end

