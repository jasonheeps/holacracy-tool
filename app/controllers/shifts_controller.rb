class ShiftsController < ApplicationController
  def new
    authorize @shift = Shift.new
    set_page_data
  end

  def create
    authorize @shift = Shift.new(shift_params)
    if @shift.save
      # TODO: update valid_until accordingly.
      # BUT HOW? When do I know that it's a new shift?
      # shifts = current_user.employee.shifts.where(weekday: @shift.weekday)
      redirect_to user_dashboard_path(current_user)
    else
      set_page_data
      render :new
    end
  end

  def edit
    authorize @shift = Shift.find(params[:id])
    set_page_data
  end

  def update
    authorize @shift = Shift.find(params[:id])
    @shift.update(shift_params)
    if @shift.save
      redirect_to user_dashboard_path(current_user)
    else
      set_page_data
      render :edit
    end
  end

  def destroy
    authorize shift = Shift.find_by_id(params[:id])
    shift.destroy
    redirect_to user_dashboard_path(current_user)
  end

  private

  def roles_input
    current_user.employee.role_fillings.map { |rf| [rf.role.title, rf.id] }
  end

  def weekdays_input
    [
      ['Montag', :monday],
      ['Dienstag', :tuesday],
      ['Mittwoch', :wednesday],
      ['Donnerstag', :thursday],
      ['Freitag', :friday],
      ['Samstag', :saturday],
      ['Sonntag', :sunday]
    ]
  end

  def set_page_data
    @roles_input = roles_input
    @weekdays_input = weekdays_input
    @shifts = current_user.employee.shifts_sorted
    @errors = @shift.errors.full_messages
  end

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
