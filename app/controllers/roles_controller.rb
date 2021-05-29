class RolesController < ApplicationController
  def index
    @roles = policy_scope(Role)
  end

  def show
    authorize @role = Role.find_by_id(params[:id])
    @tabs = tabs
    @dataset_ids = @tabs.map { |t| t[:dataset_id] }
  end

  def edit
    authorize @role = Role.find_by_id(params[:id])
  end

  def update
    authorize @role = Role.find_by_id(params[:id])
    @role.update(role_params)
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

  def role_params
    params.require(:role).permit(:acronym, :title, :url)
  end
end
