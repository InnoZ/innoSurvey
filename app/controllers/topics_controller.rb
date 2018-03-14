class TopicsController < ApplicationController
  def show
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
    # Get all statements
    statements = Statement.all.index_by(&:id)
    statement_sets = StatementSet.all.index_by(&:id)
    # Get all answers for a given user id
    user_answers = Answer.where(uuid: params[:id])
    # Iterate answers and 
    topic_ids = user_answers.map do |a| 
      statement_sets[statements[a.statement_id].statement_set_id].topic_id
    end
    render json: topic_ids.uniq, status:200
  end
end

