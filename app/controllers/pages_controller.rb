class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def overview
    @circles = policy_scope(Circle)
  end

  def user_dashboard
    @shift = Shift.new
    @roles_input = roles_input
    @weekdays_input = weekdays_input
    @shifts = current_user.employee.shifts
  end

  private

  def roles_input
    current_user.employee.role_fillings.map { |rf| [rf.role.title, rf.id] }
  end

  def weekdays_input
    [
      ['Montag', :monday],
      ['Dienstag', :tuesday],
      ['Mittwoch', :wednesday],
      ['Donnerstag', :thursday],
      ['Freitag', :friday],
      ['Samstag', :saturday],
      ['Sonntag', :sunday]
    ]
  end
end
