class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:sessions][:email])

    if @user && @user.authenticate(params[:sessions][:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      redirect_to '/login'
      flash[:danger] = ('.login_error')
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
