class EmployeesController < ApplicationController
  def index
    @employees = policy_scope(Employee)
  end

  def show
    authorize @employee = Employee.find_by_id(params[:id])
    @tabs = tabs
    @dataset_ids = @tabs.map { |t| t[:dataset_id] }
  end

  private

  def tabs
    [
      { name: 'Übersicht', dataset_id: 'employee-overview' },
      { name: 'Kalender', dataset_id: 'employee-calendar' }
    ]
  end
end
