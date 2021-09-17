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

  def new
    authorize @employee = Employee.new
    @user = @employee.user
  end

  def create
    # first create the user which will be linked to the employee
    user = User.create!(user_params)
    # then instanciate the employee with that user...
    authorize @employee = Employee.new(user: user)
    # ... and assign remaining entries
    @employee.update(employee_params)

    if @employee.save && user.save
      redirect_to account_management_path
    else
      render :new
    end
  end


  def update
    authorize employee = current_user.employee
    employee.update(employee_params) if employee
    redirect_to user_profile_path(current_user)
  end

  private

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :nickname, :photo)
  end

  def user_params
    params.permit(:email, :password, :admin)
  end

  def tabs
    [
      { name: 'Übersicht', dataset_id: 'employee-overview' },
      { name: 'Kalender', dataset_id: 'employee-calendar' }
    ]
  end
end
