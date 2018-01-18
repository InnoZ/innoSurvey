class AnswersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def answer_question_set
    respond_to do |format|
      format.json do
        unless contains_invalid_answer?
          answers.each { |answer| Answer.create(answer) }
          render(json: nil, status: :created)
        else
          render(json: nil, status: :unprocessable_entity)
        end
      end
    end
  end

  private

  def contains_invalid_answer?
    validations = answers.map { |answer| valid_answer?(answer)  }
    validations.include? false
  end

  def valid_answer?(answer_attr)
    answer = Answer.new prepare(answer_attr)
    answer.valid?
  end

  def prepare(answer_attr)
    answer_attr[:selected_choices].map!(&:to_i)
    answer_attr
  end

  def answers
    params.permit(answers: [ :statement_id, selected_choices: [] ])[:answers]
  end
end
