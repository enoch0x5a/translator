class ApplicationController < ActionController::Base
  helper_method :current_user,
                :authorize,
                :current_user_session

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

protected
  def authorize
    redirect_to login_url unless current_user
  end

  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    # @current_user ||= User.find(session[:user_id]) if session[:user_id]
    @current_user ||= UserSession.find.try(:record)
  end
end
