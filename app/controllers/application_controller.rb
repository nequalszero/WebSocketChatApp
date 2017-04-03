class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  private
  def current_user
    User.find_by_session_token(session[:session_token])
  end

  def sign_in(user)
    session[:session_token] = user.reset_session_token!
  end

  def sign_out
    current_user.try(:reset_session_token!)
    session[:session_token] = nil
  end

  def require_logged_in
    render json: ['You must be logged in to do that.'], status: 401 unless current_user
  end
end
