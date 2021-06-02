class EmployeesController < ApplicationController
  def index
    @employees = policy_scope(Employee)
  end

  def show
    authorize @employee = Employee.find_by_id(params[:id])
    @tabs = tabs
    @dataset_ids = @tabs.map { |t| t[:dataset_id] }
  end

  def update
    authorize employee = User.find_by_id(params[:id]).employee
    employee.update(employee_params) if @employee
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
