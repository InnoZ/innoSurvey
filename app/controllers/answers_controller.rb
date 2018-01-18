class AnswersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def answer_question_set
    respond_to do |format|
      format.json do
        answers.each { |answer| Answer.create(answer) }
        render(json: nil, status: :created)
      end
    end
  end

  private

  def answers
    params.permit(answers: [ :statement_id, selected_choices: [] ])[:answers]
  end
end
