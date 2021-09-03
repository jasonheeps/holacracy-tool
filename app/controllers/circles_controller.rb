require 'humanize'

class CirclesController < ApplicationController
  def new
    super_circle = Circle.find_by_id(params[:id])
    authorize @circle = Circle.new(super_circle: super_circle)
    set_circles_collection
  end

  def create
    authorize @circle = Circle.new(circle_params)
    if @circle.save
      @circle.create_circle_roles
      redirect_to circle_path(@circle)
    else
      render :new
    end
  end

  def index
    @circles = policy_scope(Circle)
  end

  def show
    authorize @circle = Circle.find_by_id(params[:id])
    @tabs = tabs
    @dataset_ids = @tabs.map { |t| t[:dataset_id] }
    # @roles = @circle.roles_unique
    @roles = @circle.roles_sorted
    @employees = @circle.employees_sorted
    @employees_roles = {}
    @employees.each do |e|
      @employees_roles[e] = e.roles_in(@circle)
    end
    @shifts_data = shifts_data
    # for testing chartkick
    @chart_data = {
      a: 2,
      b: 5,
      c: 6,
      d: -1
    }
    @circle_html = @circle.init_circles_html(false)
    @circle_html_data = @circle.init_circles_html_data(false)
  end

  def edit
    authorize @circle = Circle.find_by_id(params[:id])
    set_circles_collection
  end

  def update
    authorize @circle = Circle.find_by_id(params[:id])
    # overwrite empty string with nil
    # TODO: find smarter solution
    params = circle_params
    params[:acronym] = nil if params[:acronym] == ''
    if @circle.update(params)
      redirect_to circle_path(@circle)
    else
      render :edit
    end
  end
  
  def destroy
    authorize @circle = Circle.find_by_id(params[:id])
    handle_roles_before_circle_destroy
    @circle.destroy
    redirect_to overview_path
  end

  private

  def handle_roles_before_circle_destroy
    roles = @circle.roles
    roles.each do |role|
      if role.custom?
        role.primary_circle = @circle.super_circle
        role.save
      else
        role.destroy
      end
    end
    @circle.lead_link_role.destroy
  end

  def set_circles_collection
    @circles_collection = Circle.collection
  end

  def tabs
    [
      { name: 'Übersicht', dataset_id: 'circle-overview' },
      # { name: 'Kreisbeschreibung', dataset_id: 'circle-description' },
      { name: 'Rollen', dataset_id: 'circle-roles' },
      { name: 'soulies', dataset_id: 'circle-employees' }
      # { name: 'Metrics', dataset_id: 'circle-metrics' },
      # { name: 'Arbeitszeiten', dataset_id: 'circle-shifts' }
    ]
  end

  def shifts_data
    shifts_data = {}
    @circle.shifts.each do |s|
      shifts_data[s.id] = {
        weekday: s.weekday,
        start_row: time_to_row_name(s.time_start.to_time),
        end_row: time_to_row_name(s.time_end.to_time)
      }
    end
    shifts_data
  end

  def time_to_row_name(time)
    hour = time.hour
    hour += 1 if (53..59).to_a.include?(time.min)
    row_name = hour.humanize.gsub(/\s/, '-')

    min = round_minute_to_quarter(time.min)
    row_name += "-#{min.humanize.gsub(/\s/, '-')}" if min.positive?
    row_name
  end

  def round_minute_to_quarter(minute)
    case minute
    when 0..7, 53..59
      0
    when 8..22
      15
    when 23..37
      30
    when 38..52
      45
    end
  end

  def circle_params
    params.require(:circle).permit(:acronym, :title, :super_circle_id)
  end
end
