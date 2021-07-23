class RolesController < ApplicationController
  def new
    authorize @role = Role.new
    set_circles_form_input
  end

  def create
    authorize @role = Role.new(prepared_role_params)
    if @role.save
      redirect_to roles_path
    else
      render :new
    end
  end

  def index
    if params[:query].present?
      @roles = policy_scope(Role.search_by_title_and_acronym(params[:query]))
    else
      @roles = policy_scope(Role)
    end
  end

  def show
    authorize @role = Role.find_by_id(params[:id])
    @tabs = tabs
    @dataset_ids = @tabs.map { |t| t[:dataset_id] }
  end

  def edit
    authorize @role = Role.find_by_id(params[:id])
    set_circles_form_input
  end

  def update
    authorize @role = Role.find_by_id(params[:id])
    @role.update(prepared_role_params)
    redirect_to role_path(@role)
  end

  private

  def tabs
    [
      { name: 'Übersicht', dataset_id: 'role-overview' },
      { name: 'Rollenbeschreibung', dataset_id: 'role-description' },
      { name: 'Metrics', dataset_id: 'role-metrics' }
    ]
  end

  def set_circles_form_input
    @circles_collection = Circle.all.map { |circle| [circle.title, circle.id] }
    primary_circle = @role.primary_circle
    @primary_circle_input = [primary_circle.title, primary_circle.id]
    secondary_circle = @role.secondary_circle
    @secondary_circle_input = secondary_circle ? [secondary_circle.title, secondary_circle.id] : ['', nil]
  end

  def role_params
    params.require(:role).permit(:acronym, :title, :url, :primary_circle_id, :secondary_circle_id)
  end

  def prepared_role_params
    params = role_params
    params[:primary_circle] = Circle.find_by_id(params[:primary_circle_id].to_i)
    params[:secondary_circle] = Circle.find_by_id(params[:secondary_circle_id].to_i) if params[:secondary_circle_id]
    # if user edits role but leaves acronym blank
    # --> overwrite empty string with nil
    params[:acronym] = nil if params[:acronym] == '' 
    params
  end 

end
