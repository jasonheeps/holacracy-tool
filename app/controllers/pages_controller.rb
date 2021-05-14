class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def overview
    circles = policy_scope(Circle)
    gcc = circles.find_by(acronym: 'GCC')
    circles_data = circle_to_hash(gcc)
    @circles_html = "
      <div class='circle-0'>\n
        <div class='circle-title-container'>\n
          <h2 class='circle-title's>GCC</h2>\n
        </div>\n
        #{create_circles_html(circles_data)}
      </div>"
  end

  def user_dashboard
    set_shifts
  end

  private

  def circle_to_hash(circle)
    return {
      title: circle.acronym || circle.title,
      parent_circle: circle,
      roles: circle.roles,
      roles_count_total: circle.roles_count_total,
      sub_circles: circle.sub_circles.map { |sc| circle_to_hash(sc) }
    }
  end

  # returns the total number of roles within this circle
  # including roles of subcircles
  def roles_count_total(circle)
    count = circle.roles.count
    circle.subcircles.each do |sc|
      count += roles_count(sc)
    end
    return count
  end

  def create_circles_html(data)
    html = ""
    data[:sub_circles].each do |sc|
      html += "
        <div class='subcircle'>\n
          <div class='circle-title-container'>\n
            <h2 class='circle-title'>#{sc[:title]}</h2>\n
          </div>\n
          #{create_circles_html(sc)}\n
          #{create_roles_html(sc[:roles])}
        </div>\n"
    end
    return html
  end

  def create_roles_html(roles)
    html = ""
    # TODO: migrate r.acronym and use it here instead of title if possible
    roles.each do |r|
      html += "
        <div class='role'>\n
          <div class='role-title-container'>\n
            <p class='role-title'>#{r.title}</p>\n
          </div>
        </div>\n"
    end
    return html
  end

  def set_shifts
    shifts = current_user.employee.shifts
    @shifts = {}
    %i[monday tuesday wednesday thursday friday saturday sunday].each do |d|
      @shifts[d] = shifts.where(weekday: d).sort_by(&:time_start)
    end
  end
end
