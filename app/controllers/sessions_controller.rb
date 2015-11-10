class SessionsController < ApplicationController
  force_ssl if Rails.env.production?
# TODO: authlogic

  #login
  def new
    if session[:user_id]
      session.reset unless current_user
      redirect_to translations_url
    end
  end

  def create
    if (user = User.find_by(name: params[:name]).try(:authenticate, params[:password]))
      session[:user_id] = user.id
    else
      flash[:alert] = 'login failed, please try again'
    end
    redirect_to root_url
  end

  #logout
  def destroy
    session.clear
    redirect_to root_url
  end
end
