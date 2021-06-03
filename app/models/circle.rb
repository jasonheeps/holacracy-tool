class Circle < ApplicationRecord
  has_many :roles, foreign_key: 'primary_circle_id'
  has_many :role_fillings, through: :roles
  has_many :employees, through: :role_fillings
  has_many :shifts, through: :role_fillings
  belongs_to :super_circle, class_name: 'Circle', foreign_key: 'super_circle_id', optional: true
  has_many :accountabilities, class_name: 'CircleAccountability', dependent: :destroy

  # def roles_unique
  #   roles.uniq.sort_by(&:title)
  # end

  def roles_sorted
    roles.sort_by(&:title)
  end

  def employees_unique
    employees.uniq.sort_by(&:first_name)
  end

  def sub_circles
    Circle.where(super_circle_id: id)
  end

  def lead_link
    if level.zero?
      ll_role = Role.find_by(role_type: 'll', primary_circle_id: id)
    else
      ll_role = Role.find_by(role_type: 'll', secondary_circle_id: id)
    end
    # ToDo: remove safety '&'
    # what if ll is not covered?
    ll_role&.ccms&.first
  end

  def rep_link
    rl_role = Role.find_by(role_type: 'rl', primary_circle_id: id)
    # ToDo: remove safety '&'
    rl_role&.ccms&.first
  end

  def facilitator
    fac_role = Role.find_by(role_type: 'fac', primary_circle_id: id)
    # ToDo: remove safety '&'
    fac_role&.ccms&.first
  end

  def secretary
    sec_role = Role.find_by(role_type: 'sec', primary_circle_id: id)
    # ToDo: remove safety '&'
    sec_role&.ccms&.first
  end

  def cross_link(circle)
  end

  # GCC has level 0
  # subcircles of GCC have level 1
  # subcircles of subcircles of GCC have level 2
  # and so on...
  def level(circle = self)
    return 0 unless circle.super_circle

    1 + level(circle.super_circle)
  end

  def super_circle
    Circle.find_by_id(super_circle_id)
  end

  # returns the total number of roles within this circle
  # including roles of subcircles
  def roles_count_total
    count = roles.to_a.count
    sub_circles.each do |sc|
      count += sc.roles_count_total
    end
    count
  end

  def init_circles_html(with_sc_roles = true)
    # circles = Circle.all
    # TODO: find most outer circle by more general attribute like 'level'
    # gcc = circles.find_by(acronym: 'GCC')
    circles_data_hash = circle_to_hash
    "<div class='circle-0'>\n
      <a href='/circles/#{id}'>\n
        <div class='circle-title-container'>\n
          <h2 class='circle-title's>#{title}</h2>\n
        </div>\n
      </a>
      #{
        if with_sc_roles
          Circle.create_sub_circles_html(circles_data_hash)
        else
          Circle.create_sub_circles_html_without_roles(circles_data_hash)
        end
      }
      #{Circle.create_roles_html(roles)}
    </div>"
  end

  def circle_to_hash
    {
      circle: self,
      roles_count_total: roles_count_total,
      sub_circles: sub_circles.map(&:circle_to_hash)
    }
  end

  private

  def self.create_sub_circles_html(circles_hash)
    html = ""
    sub_circles_hash = circles_hash[:sub_circles]
    sub_circles_hash.each do |sc_hash|
      sc = sc_hash[:circle]
      html += "
        <div class='subcircle'>\n
          <a href='/circles/#{sc.id}'>\n
            <div class='circle-title-container'>\n
              <h2 class='circle-title'>#{sc.title}</h2>\n
            </div>\n
          </a>
          #{Circle.create_sub_circles_html(sc_hash)}\n
          #{Circle.create_roles_html(sc.roles)}
        </div>\n"
    end
    return html
  end

  def self.create_sub_circles_html_without_roles(circles_hash)
    html = ""
    sub_circles_hash = circles_hash[:sub_circles]
    sub_circles_hash.each do |sc_hash|
      sc = sc_hash[:circle]
      html += "
        <div class='subcircle'>\n
          <a href='/circles/#{sc.id}'>\n
            <div class='circle-title-container'>\n
              <h2 class='circle-title'>#{sc.title}</h2>\n
            </div>\n
          </a>
        </div>\n"
    end
    return html
  end

  def self.create_roles_html(roles)
    html = ""
    roles = roles.sort_by(&:title)
    # TODO: migrate r.acronym and use it here instead of title if possible
    roles.each do |r|
      html += "
        <div class='role #{'circle-role' if r.circle_role?}'>\n
          <a href='/roles/#{r.id}'>\n
            <div class='role-title-container'>\n
              <p class='role-title'>#{r.acronym || r.title}</p>\n
            </div>\n
          </a>\n
        </div>\n"
    end
    return html
  end

  def circle_hirarchy_data
    data = {}
    Circle.all.each do |c|
      data[c.acronym || c.title] = {
        circle: c,
        level: c.level,
        sub_circles: c.sub_circles
      }
    end
  end
end
