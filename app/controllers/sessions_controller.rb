class SessionsController < ApplicationController
  force_ssl if Rails.env.production?

  def new
    if session[:user_id]
      session.reset unless User.find(session[:user_id])
      redirect_to translations_path
    end
  end

  def create
    if (user = User.where(name: params[:name]).try(:authenticate, params[:password]))
      session[:user_id] = user.id
    else
      flash[:alert] = 'login failed, please try again'
    end
    redirect_to root_path
  end

  def destroy
    session.clear
    redirect_to root_path
  end
end
