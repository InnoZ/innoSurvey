class AnswersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def mock
    p 'POST REQUEST ARRIVED: '
    p params
  end
end
