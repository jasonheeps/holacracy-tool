class EmployeesController < ApplicationController
  def index
    @employees = policy_scope(Employee)
  end
end
