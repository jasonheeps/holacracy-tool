class RoleFillingsController < ApplicationController
  def new
    role = Role.find_by_id(params[:id])
    authorize @role_filling = RoleFilling.new(role: role)
  end
end
