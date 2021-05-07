class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def overview
    @circles = policy_scope(Circle)

  end

  def user_dashboard
    set_shifts
  end

  private

  def set_shifts
    shifts = current_user.employee.shifts
    @shifts = {}
    %i[monday tuesday wednesday thursday friday saturday sunday].each do |d|
      @shifts[d] = shifts.where(weekday: d).sort_by(&:time_start)
    end
  end
end
