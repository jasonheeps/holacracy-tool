require 'humanize'

class CirclesController < ApplicationController
  def index
    @circles = policy_scope(Circle)
  end

  def show
    authorize @circle = Circle.find_by_id(params[:id])
    @tabs = tabs
    @dataset_ids = @tabs.map { |t| t[:dataset_id] }
    # @roles = @circle.roles_unique
    @roles = @circle.roles_sorted
    @employees = @circle.employees_unique
    @shifts_data = shifts_data
    # for testing chartkick
    @chart_data = {
      a: 2,
      b: 5,
      c: 6,
      d: -1
    }
    @circle_html = @circle.init_circles_html(false)
  end

  def edit
    authorize @circle = Circle.find_by_id(params[:id])
    @super_circles_collection = super_circles_collection
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

  private

  def super_circles_collection
    Circle.all.map { |c| [c.title, c.id] }
  end

  def tabs
    [
      { name: 'Übersicht', dataset_id: 'circle-overview' },
      # { name: 'Kreisbeschreibung', dataset_id: 'circle-description' },
      { name: 'Rollen', dataset_id: 'circle-roles' },
      { name: 'Soulies', dataset_id: 'circle-employees' }
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
