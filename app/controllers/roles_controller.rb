class RolesController < ApplicationController
  def index
    @roles = policy_scope(Role)
  end

  def show
    authorize @role = Role.find_by_id(params[:id])
    @tabs = tabs
    @dataset_ids = @tabs.map { |t| t[:dataset_id] }
  end

  private

  def tabs
    [
      { name: 'Übersicht', dataset_id: 'role-overview' },
      { name: 'Rollenbeschreibung', dataset_id: 'role-description' },
      { name: 'Metrics', dataset_id: 'role-metrics' }
    ]
  end
end
