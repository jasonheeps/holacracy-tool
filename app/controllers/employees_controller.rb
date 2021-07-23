class EmployeesController < ApplicationController
  def index
    if params[:query].present?
      @employees = policy_scope(Employee.search_by_name_and_nickname(params[:query])).sort_by(&:first_name)
    else
      @employees = policy_scope(Employee).sort_by(&:first_name)
    end
    # TODO: use brand colors (if any)
    @colors = {}
    @employees.each do |e|
      hue = rand * 360
      @colors[e.id] = hue
    end
  end

  def show
    authorize @employee = Employee.find_by_id(params[:id])
    @tabs = tabs
    @dataset_ids = @tabs.map { |t| t[:dataset_id] }
    @circles = @employee.circles
    @roles = @employee.roles_sorted
  end

  def update
    authorize employee = current_user.employee
    employee.update(employee_params) if employee
    redirect_to user_profile_path(current_user)
  end

  private

  def employee_params
    params.require(:employee).permit(:photo)
  end

  def tabs
    [
      { name: 'Übersicht', dataset_id: 'employee-overview' },
      { name: 'Kalender', dataset_id: 'employee-calendar' }
    ]
  end
end
