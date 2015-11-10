class UsersController < ApplicationController
  force_ssl if Rails.env.production?

  helper_method :user
  before_action :authorize, only: [:destroy]

  def new
    redirect_to root_url if current_user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = user.id
    end
  end

  def destroy
    current_user.destroy
    session.clear
    redirect_to sign_off_url
  end

protected
  def user
    @user ||= User.new
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
