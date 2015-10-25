class UsersController < ApplicationController
  force_ssl if Rails.env.production?

  helper_method :user

  def new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = user.id
      redirect_to root_path
    else
      render new
    end
  end

protected
  def user
    @user ||= User.new
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end