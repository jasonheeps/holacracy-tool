class RoleFillingsController < ApplicationController
  def new
    @role = Role.find_by_id(params[:id])
    circle = @role.primary_circle
    authorize @role_filling = RoleFilling.new(role: @role)
    set_form_input
  end

  def create
    # authorize @role_filling = RoleFilling.new(role_filling_params)
    authorize @role_filling = RoleFilling.new(prepared_role_filling_params)
    if @role_filling.save
      redirect_to role_path(@role_filling.role)
    else
      render :new
    end
  end

  private

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
