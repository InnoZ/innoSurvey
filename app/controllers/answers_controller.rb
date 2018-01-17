class AnswersController < ApplicationController
  def answer_question_set
    respond_to do |format|
      format.json do
        answers.each { |answer| Answer.create(answer) }
      end
    end
  end

  private

  def answers_to_hash
    JSON.parse params["answers"]
  end

  def answers
    answers_to_hash["answers"]
  end
end
