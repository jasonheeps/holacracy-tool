class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def overview
    circles = policy_scope(Circle)
    gcc = circles.find_by(acronym: 'GCC')
    @circles_data = circle_to_hash(gcc)
    @circles_html = "
      <div class='circle-0'>\n
        <a href='/circles/#{gcc.id}'>\n
          <div class='circle-title-container'>\n
            <h2 class='circle-title's>GCC</h2>\n
          </div>\n
        </a>
        #{create_circles_html(@circles_data)}
        #{create_roles_html(gcc.roles)}
      </div>"
  end

  def user_dashboard
    set_shifts
  end

  private

  def circle_to_hash(circle)
    return {
      title: circle.acronym || circle.title,
      id: circle.id,
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
          <a href='/circles/#{sc[:id]}'>\n
            <div class='circle-title-container'>\n
              <h2 class='circle-title'>#{sc[:title]}</h2>\n
            </div>\n
          </a>
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
          <a href='/roles/#{r.id}'>\n
            <div class='role-title-container'>\n
              <p class='role-title'>#{r.title}</p>\n
            </div>\n
          </a>\n
        </div>\n"
    end
    return html
  end

  # def circle_size_string(circle_data)
  #   roles_count = circle_data[:roles_count_total]
  #   size = Math.sqrt(roles_count * 100.fdiv(79) * role_size)
  #   "style='--size: #{size}px;'"
  # end

  # def role_size
  #   # the first number is the height of the orgchart in px
  #   2000 * Math.sqrt(79.fdiv(100 * all_roles_count))
  # end

  # def role_size_string
  #   "style='--size: #{role_size}px;'"
  # end

  # def all_roles_count
  #   @circles_data[:roles_count_total]
  # end

  def set_shifts
    shifts = current_user.employee.shifts
    @shifts = {}
    %i[monday tuesday wednesday thursday friday saturday sunday].each do |d|
      @shifts[d] = shifts.where(weekday: d).sort_by(&:time_start)
    end
  end
end
