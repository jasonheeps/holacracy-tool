class RolesController < ApplicationController
  def new
    @circle = Circle.find_by_id(params[:id])
    authorize @role = Role.new(primary_circle: @circle)
    set_form_input(role_types: [:cl, :custom])
  end

  def create
    authorize @role = Role.new(prepared_role_params)
    if @role.save
      redirect_to role_path(@role)
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
    set_form_input(role_types: [:cl, :custom, :fac, :ll, :rl, :sec])
    @role_type_value = @role.role_type
  end

  def update
    authorize @role = Role.find_by_id(params[:id])
    if @role.update(prepared_role_params)
      redirect_to role_path(@role)
    else
      render :edit
    end
  end

  def destroy
    authorize @role = Role.find_by_id(params[:id])
    circle = @role.primary_circle
    @role.destroy
    redirect_to circle_path(circle)
  end

  private

  # tabs for show page
  def tabs
    [
      { name: 'Übersicht', dataset_id: 'role-overview' },
      { name: 'Rollenbeschreibung', dataset_id: 'role-description' },
      { name: 'Metrics', dataset_id: 'role-metrics' }
    ]
  end

  # defines form input data
  def set_form_input(params)
    set_types_collection
    set_circles_collection
    set_form_values
  end

  # role types dropwdown for the form input
  def set_types_collection
    @types_collection = []
    params[:role_types].each do |type|
      @types_collection << [role_types[type], type] 
    end
  end

  # humanizes 'role_types'
  def role_types
    {
      custom: 'Benutzerdefinierte Rolle',
      cl: 'Cross Link',
      fac: 'Facilitator',
      ll: 'Lead Link',
      rl: 'Rep Link',
      sec: 'Secretary'
    }
  end

  # circles dropdown for the form input
  def set_circles_collection
    @circles_collection = Circle.collection
  end

  # prefilled values for the form inputs
  def set_form_values
    primary_circle = @role.primary_circle
    @primary_circle_id_value = primary_circle ? primary_circle.id : nil
    secondary_circle = @role.secondary_circle
    @secondary_circle_id_value = secondary_circle ? secondary_circle.id : nil
  end

  def role_params
    params.require(:role).permit(:acronym, :title, :url, :primary_circle_id, :secondary_circle_id, :role_type)
  end

  def prepared_role_params
    params = role_params
    # if user edits role but leaves acronym blank
    # --> overwrite empty string with nil
    # TODO: add a validation instead (that acronym can't be empty)
    params[:acronym] = nil if params[:acronym] == '' 
    params
  end 
end
