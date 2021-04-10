class CirclesController < ApplicationController
  def index
    @circles = policy_scope(Circle)
  end

  def show
    authorize @circle = Circle.find_by_id(params[:id])
    @tabs = tabs
    @dataset_ids = @tabs.map { |t| t[:dataset_id] }
    @roles = @circle.roles_unique
    @employees = @circle.employees_unique
  end

  private

  def tabs
    [
      { name: 'Übersicht', dataset_id: 'circle-overview' },
      { name: 'Kreisbeschreibung', dataset_id: 'circle-description' },
      { name: 'Rollen', dataset_id: 'circle-roles' },
      { name: 'Soulies', dataset_id: 'circle-employees' },
      { name: 'Metrics', dataset_id: 'circle-metrics' },
      { name: 'Arbeitszeiten', dataset_id: 'circle-shifts' }
    ]
  end

  # def get_employee_shifts
  #   employee_shifts = {}
  #   @employees.each do |e|
  #     e.shifts.each do |s|
  #       employee_shifts[e.id.to_sym] = {
  #         weekday: s.weekday,
  #         role: s.role.title,
  #         time_start:
  #       }
  #     end
  #   end
  # end
end
