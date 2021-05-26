class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def user_dashboard
    set_shifts
  end

  def overview
    # @circles_html = init_circles_html
    circles = Circle.all
    gcc = circles.find_by(acronym: 'GCC')
    @circles_html = gcc.init_circles_html
  end

  private

  # TODO: Remove html methods after testing (moved to circle.rb)
  # def init_circles_html
  #   circles = Circle.all
  #   # TODO: find most outer circle by more general attribute like 'level'
  #   gcc = circles.find_by(acronym: 'GCC')
  #   circles_data_hash = gcc.circle_to_hash
  #   "<div class='circle-0'>\n
  #     <a href='/circles/#{gcc.id}'>\n
  #       <div class='circle-title-container'>\n
  #         <h2 class='circle-title's>GCC</h2>\n
  #       </div>\n
  #     </a>
  #     #{create_sub_circles_html(circles_data_hash)}
  #     #{create_roles_html(gcc.roles)}
  #   </div>"
  # end

  # def create_sub_circles_html(circles_hash)
  #   html = ""
  #   sub_circles_hash = circles_hash[:sub_circles]
  #   sub_circles_hash.each do |sc_hash|
  #     sc = sc_hash[:circle]
  #     html += "
  #       <div class='subcircle'>\n
  #         <a href='/circles/#{sc.id}'>\n
  #           <div class='circle-title-container'>\n
  #             <h2 class='circle-title'>#{sc.title}</h2>\n
  #           </div>\n
  #         </a>
  #         #{create_sub_circles_html(sc_hash)}\n
  #         #{create_roles_html(sc.roles)}
  #       </div>\n"
  #   end
  #   return html
  # end

  # def create_roles_html(roles)
  #   html = ""
  #   # TODO: migrate r.acronym and use it here instead of title if possible
  #   roles.each do |r|
  #     html += "
  #       <div class='role'>\n
  #         <a href='/roles/#{r.id}'>\n
  #           <div class='role-title-container'>\n
  #             <p class='role-title'>#{r.title}</p>\n
  #           </div>\n
  #         </a>\n
  #       </div>\n"
  #   end
  #   return html
  # end

  def set_shifts
    shifts = current_user.employee.shifts
    @shifts = {}
    %i[monday tuesday wednesday thursday friday saturday sunday].each do |d|
      @shifts[d] = shifts.where(weekday: d).sort_by(&:time_start)
    end
  end
end
