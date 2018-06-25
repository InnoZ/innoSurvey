class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  # makes it available in views
  helper_method :current_user

  def authenticate
    return false if current_user
    redirect_to root_path
  end
end
