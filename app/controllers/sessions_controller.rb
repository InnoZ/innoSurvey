class SessionsController < ApplicationController
  before_action :set_cors, only: [:gen_uuid]

  def new
  end

  def create
    @user = User.find_by_email(params[:sessions][:email])

    if @user && @user.authenticate(params[:sessions][:password])
      session[:user_id] = @user.id
      redirect_to surveys_path
    else
      flash[:danger] = t('session.login_error')
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  def gen_uuid
    uuid = SecureRandom.urlsafe_base64(6)
    token = uuid.to_s.encrypt

    render json: {
      uuid: uuid,
      token: token
    }, status: 200
  end
end
