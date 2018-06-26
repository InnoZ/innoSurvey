class TopicsController < ApplicationController
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
end

