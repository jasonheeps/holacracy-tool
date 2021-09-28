class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  before_action :authorize_users, only: [:account_management, :admin_console]

  def account_management
    # before_action 'authorize_users' assigned @users
    @users_activated = User.activated.ordered_by_email
    @users_deactivated = User.deactivated.ordered_by_email
  end

  def admin_console
    # before_action 'authorize_users' assigned @users
  end

  def home
  end

  def user_dashboard
    # set_shifts
    @employee = current_user.employee
    set_roles_data
  end

  def user_profile
    @employee = current_user.employee
  end

  def orgchart
    # @circles_html = init_circles_html
    circles = Circle.all
    gcc = circles.find_by(acronym: 'GCC')
    @circles_html = gcc.init_circles_html
  end

  private

  def set_roles_data
    # guard clause for accounts without employee, e.g. it@soulbottles.com
    return unless @employee

    roles = @employee.roles.ordered_by_title
    @roles_data = roles.map do |r|
      {
        role: r,
        role_filling: @employee.role_fillings.find_by(role: r),
        acronym: r.acronym,
        title: r.title,
        primary_circle: r.primary_circle,
        secondary_circle: r.secondary_circle,
        status: r.status_string(@employee)
      }
    end
  end

  # def set_shifts
  #   shifts = current_user.employee.shifts
  #   @shifts = {}
  #   %i[monday tuesday wednesday thursday friday saturday sunday].each do |d|
  #     @shifts[d] = shifts.where(weekday: d).sort_by(&:time_start)
  #   end
  # end

  private

  def authorize_users
    @users = policy_scope(User.all)
  end

end
