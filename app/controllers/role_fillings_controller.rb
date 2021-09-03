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
    @employee_id_value = @role_filling.employee.id
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
    @employees_collection = Employee.collection
    @roles_collection = Role.collection
    @role_title = @role.title
    @role_value = @role.id 
    @role_filling_statuses_collection = []
    RoleFilling.role_filling_statuses.each do |key, value|
      @role_filling_statuses_collection << [RoleFilling.enum_to_s(key), value]
    end
  end
end
