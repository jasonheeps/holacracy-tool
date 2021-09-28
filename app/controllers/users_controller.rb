class UsersController < ApplicationController
  before_action :authorize_user, only: [:toggle_deactivated]

  def new
    authorize @user = User.new
  end

  def create
    authorize @user = User.new(user_params)
    if @user.save
      redirect_to account_management_path
    else
      render :new
    end
  end

  def toggle_deactivated
    @user.update(deactivated: !@user.deactivated?)
    redirect_to account_management_path
  end

  private 

  def authorize_user
    authorize @user = User.find_by_id(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :admin)
  end
end
