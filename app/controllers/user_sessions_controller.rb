class UserSessionsController < ApplicationController
  helper_method :user_session

  force_ssl if Rails.env.production?

  #login
  def new
    if current_user_session
      redirect_to translations_url
    end
  end

  def create
    @user_session = UserSession.create(user_session_params)
    if @user_session.save
      redirect_to translations_url
    else
      @user_session.errors.full_messages.each_with_index do |msg, index|
        flash[:"#{index}"] = msg
      end

      redirect_to login_url
    end
  end

  #logout
  def destroy
    current_user_session.destroy
    redirect_to root_url
  end
private

  def user_session
    @user_session ||= UserSession.new
  end

  def user_session_params
    params.require(:user_session).permit(:email, :password)
  end
end


