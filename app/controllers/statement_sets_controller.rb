class StatementSetsController < ApplicationController
  before_action :authenticate

  def new
    @statement_set = StatementSet.new(statement_set_params)
    if @statement_set.save
      redirect_to new_statement_set_statement_path(statement_set_id: @statement_set.id)
    else
      flash[:error] = @statement_set.errors
      redirect_back(fallback_location: surveys_path)
    end
  end

  private

  def statement_set_params
    params.permit(:role_id, :topic_id)
  end
end
