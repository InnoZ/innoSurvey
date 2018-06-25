class StatementsController < ApplicationController
  before_action :authenticate

  def edit
    @statement = Statement.find(params[:id])
    5.times { @statement.choices.build }
  end

  def new
    @statement_set = StatementSet.find(params[:statement_set_id])
    @statement = @statement_set.statements.new
    5.times { @statement.choices.build }
  end

  def create
    @statement_set = StatementSet.find(statement_params[:statement_set_id])
    if @statement_set.statements.new(statement_params).save
      flash[:success] = 'Saved!'
      redirect_to station_content_path(@statement_set.topic.station)
    else
      flash[:error] = 'An error occured!'
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    @statement = Statement.find(params[:id])
    if @statement.update_attributes(statement_params)
      flash[:success] = 'Saved!'
      redirect_to station_content_path(@statement.topic.station)
    else
      flash[:error] = 'An error occured!'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @statement = Statement.find(params[:id])
    if @statement.destroy
      flash[:warning] = 'Deleted!'
      redirect_to station_content_path(@statement.topic.station)
    else
      flash[:error] = 'An error occured!'
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def statement_params
    params.require(:statement).permit(:text, :statement_set_id, :style, choices_attributes: %i[id text _destroy])
  end
end
