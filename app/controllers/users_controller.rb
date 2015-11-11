class UsersController < ApplicationController
  force_ssl if Rails.env.production?

  helper_method :user
  before_action :authorize, only: [:destroy]

  def new
    redirect_to root_url if current_user_session
  end

  def create
    @user = User.create(user_params)
    if @user
      redirect_to root_path
    else
      render 'new'
    end
  end

def destroy
    current_user.destroy
    redirect_to root_url
  end

protected
  def user
    @user ||= User.new
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
