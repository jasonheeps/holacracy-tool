class ShiftsController < ApplicationController
  def new
    authorize @shift = Shift.new
    set_page_data
  end

  def create
    authorize @shift = Shift.new(shift_params)
    if @shift.save
      # TODO: add valid_until in db schema and update here accordingly
      redirect_to user_dashboard_path(current_user)
    else
      set_page_data
      render :new
    end
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
