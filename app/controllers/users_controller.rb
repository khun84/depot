class UsersController < ApplicationController
  include Devise::Controllers::Helpers
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show_current_user
    @user = current_user
    render 'show'
  end

  def show
    @user = User.find(params[:id])
    render 'show'
  end

  def edit
    @user = User.find(current_user.id)
    render 'edit'
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(users_params)
      redirect_to user_url, notice: 'Profile updated successfully'
    else
      redirect_to edit_user_url, alert: @user.errors.full_messages
    end

  end

  private
  def users_params
    params.require(:user).permit(:name)
  end

end
