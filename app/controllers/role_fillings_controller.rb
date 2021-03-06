class RoleFillingsController < ApplicationController
  before_action :find_role_filling, only: [:edit, :update, :destroy]

  def new
    @role = Role.find_by_id(params[:id])
    circle = @role.primary_circle
    authorize @role_filling = RoleFilling.new(role: @role)
    set_form_input
  end

  def create
    authorize @role_filling = RoleFilling.new(prepared_role_filling_params)
    if @role_filling.save
      redirect_to role_path(@role_filling.role)
    else
      render :new
    end
  end

  def edit
    # 'before_action' finds and authorizes '@role_filling'
    @role = @role_filling.role
    set_form_input
  end

  def update
    # 'before_action' finds and authorizes '@role_filling'
    if @role_filling.update(prepared_role_filling_params)
      redirect_to role_path(@role_filling.role)
    else
      render :edit
    end
  end

  def destroy
    # 'before_action' finds and authorizes '@role_filling'
    role = @role_filling.role
    # TODO: (for all destroy actions in all controllers:) how to catch if destroy fails?
    @role_filling.destroy
    redirect_to role_path(role)
  end

  private

  def find_role_filling
    authorize @role_filling = RoleFilling.find_by_id(params[:id])
  end

  def role_filling_params
    params.require(:role_filling).permit(:role_id, :employee_id, :role_filling_status)
  end

   def prepared_role_filling_params
     params = role_filling_params
     # role_filling_status gets passed as String, e.g. '1' and needs to be cast to integer
     params[:role_filling_status] = params[:role_filling_status].to_i
     params
   end

  def set_form_input
    # headline
    @role_title = @role.title

    # values
    @role_id_value = @role.id
    @employee_id_value = @role_filling.employee.id if @role_filling.employee
    # TODO: There must be an easier way to write this...
    @role_filling_status_value = RoleFilling.role_filling_statuses[@role_filling.role_filling_status] if @role_filling.role_filling_status

    # collections (options for dropwdown)
    @employees_collection = Employee.collection
    @roles_collection = Role.collection
    # TODO: Refactor this to its own method in role_filling.rb
    @role_filling_statuses_collection = []
    RoleFilling.role_filling_statuses.each do |key, value|
      @role_filling_statuses_collection << [RoleFilling.humanize_status(key), value]
    end
  end
end
