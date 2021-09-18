class UsersController < ApplicationController
  before_action :authorize_user, only: [:toggle_deactivated]
  
  # def activate
  #   @user.update(deactivated: false) if @user.deactivated
  #   binding.pry
  #   redirect_to account_management_path
  # end

  def toggle_deactivated
    # @user.update(deactivated: true) unless @user.deactivated
    @user.update(deactivated: !@user.deactivated?)
    redirect_to account_management_path
  end

  private 

  def authorize_user
    authorize @user = User.find_by_id(params[:id])
  end

end
