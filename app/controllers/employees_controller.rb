class EmployeesController < ApplicationController
  def index
    @employees = policy_scope(Employee)
  end

  def show
    authorize @employee = Employee.find_by_id(params[:id])
  end
end
