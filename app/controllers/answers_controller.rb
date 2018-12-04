class AnswersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def answer_question_set
    respond_to do |format|
      format.json do
        unless contains_invalid_answer? || !token_valid
          answers.each { |answer| Answer.create(answer.merge!(uuid: uuid)) }
          render(json: nil, status: :created)
        else
          render(json: nil, status: :unprocessable_entity)
        end
      end
    end
  end

  private

  def token_valid
    token.decrypt == uuid || (belongs_to_old_survey && token.decrypt == 'token4oldSurveys')
  end

  def belongs_to_old_survey
    # old survey does not have token in their qr codes
    statement_id = Statement.find(answers.first[:statement_id]).survey.id
    [5, 4].include?(statement_id)
  end

  def contains_invalid_answer?
    validations = answers.map do |answer|
      valid_answer?(answer)
    end
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
    params.permit(:uuid, :token, answers: [ :statement_id, selected_choices: [] ])[:answers]
  end

  def uuid
    params.permit(:uuid)[:uuid]
  end

  def token
    params.permit(:token)[:token]
  end
end
