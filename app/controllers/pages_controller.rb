class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def admin_console
    
  end

  def home
  end

  def user_dashboard
    set_shifts
    @employee = current_user.employee
    set_roles_data
  end

  def user_profile
    @employee = current_user.employee
  end

  def overview
    # @circles_html = init_circles_html
    circles = Circle.all
    gcc = circles.find_by(acronym: 'GCC')
    @circles_html = gcc.init_circles_html
  end

  private

  def set_roles_data
    roles = @employee.roles_sorted
    @roles_data = roles.map do |r|
      {
        role: r,
        acronym: r.acronym,
        title: r.title,
        primary_circle: r.primary_circle,
        secondary_circle: r.secondary_circle,
        status: r.status_string(@employee)
      }
    end
  end

  def set_shifts
    shifts = current_user.employee.shifts
    @shifts = {}
    %i[monday tuesday wednesday thursday friday saturday sunday].each do |d|
      @shifts[d] = shifts.where(weekday: d).sort_by(&:time_start)
    end
  end
end
