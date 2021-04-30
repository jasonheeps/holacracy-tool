class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def overview
    @circles = policy_scope(Circle)
  end

  def user_dashboard
    @shifts = current_user.employee.shifts_sorted
  end
end
