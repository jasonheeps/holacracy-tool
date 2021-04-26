class ShiftsController < ApplicationController
  def create
    authorize @shift = Shift.new(shift_params)
    if @shift.save
      redirect_to user_dashboard_path(current_user)
    else
      render 'pages/user_dashboard'
    end
  end

  private

  def shift_params
    params.require(:shift).permit(
      :role_filling_id,
      :weekday,
      :time_start,
      :time_end,
      :valid_from
    )
  end
end
