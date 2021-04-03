class CirclesController < ApplicationController
  def index
    @circles = policy_scope(Circle)
  end

  def show
    authorize @circle = Circle.find_by_id(params[:id])
    @tabs = tabs
    @roles = @circle.roles
  end

  private

  def tabs
    [
      { name: 'Übersicht', dataset_id: 'circle-overview' },
      { name: 'Kreisbeschreibung', dataset_id: 'circle-description' },
      { name: 'Rollen', dataset_id: 'circle-roles' },
      { name: 'Soulies', dataset_id: 'circle-employees' },
      { name: 'Policies', dataset_id: 'cirlce-policies' }
    ]
  end
end
