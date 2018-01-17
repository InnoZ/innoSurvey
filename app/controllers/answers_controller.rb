class AnswersController < ApplicationController
  def answer_question_set
    respond_to do |format|
      format.json do
        answers.each do |answer|
          Answer.create(statement_id: answer["statement_id"], result: answer["selected_choices"].to_s)
        end
      end
    end
  end

  private

  def results_to_hash
    JSON.parse params["answers"]
  end

  def answers
    results_to_hash["answers"]
  end
end
