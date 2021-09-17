class Circle < ApplicationRecord
  has_many :roles, foreign_key: 'primary_circle_id'
  has_many :role_fillings, through: :roles
  has_many :employees, -> { distinct }, through: :role_fillings
  has_many :shifts, through: :role_fillings
  belongs_to :super_circle, class_name: 'Circle', foreign_key: 'super_circle_id', optional: true
  has_many :accountabilities, class_name: 'CircleAccountability', dependent: :destroy

  # def roles_unique
  #   roles.uniq.sort_by(&:title)
  # end

  def self.all_sorted
    Circle.all.sort_by(&:title)
  end

  def roles_sorted
    roles.sort_by(&:title)
  end

  def employees_sorted
    employees.sort_by(&:first_name)
  end

  def sub_circles
    Circle.where(super_circle_id: id)
  end

  def lead_link_role
    if level.zero?
      Role.find_by(role_type: 'll', primary_circle_id: id)
    else
      Role.find_by(role_type: 'll', secondary_circle_id: id)
    end

  end

  def lead_link
    # TODO: remove safety '&'
    # what if ll is not covered?
    lead_link_role&.ccms&.first
  end

  def rep_link
    rl_role = Role.find_by(role_type: 'rl', primary_circle_id: id)
    # TODO: remove safety '&'
    rl_role&.ccms&.first
  end

  def facilitator
    fac_role = Role.find_by(role_type: 'fac', primary_circle_id: id)
    # TODO: remove safety '&'
    fac_role&.ccms&.first
  end

  def secretary
    sec_role = Role.find_by(role_type: 'sec', primary_circle_id: id)
    # TODO: remove safety '&'
    sec_role&.ccms&.first
  end

  def secretary_role 
    Role.find_by(primary_circle_id: id, role_type: :sec)
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

  def create_circle_roles
    Role.create!(
      title: "Lead Link #{title}",
      role_type: :ll,
      primary_circle_id: super_circle.id,
      secondary_circle_id: id,
      acronym: "LL #{acronym || title}"
    )
 
    Role.create!(
      title: "Rep Link #{title}",
      role_type: :rl,
      primary_circle_id: id,
      secondary_circle_id: super_circle.id,
      acronym: "RL #{acronym || title}"
    )
 
    Role.create!(
      title: "Secretary #{title}",
      role_type: :sec,
      primary_circle_id: id,
      acronym: "Sec #{acronym || title}"
    )
 
    Role.create!(
      title: "Facilitator #{title}",
      role_type: :fac,
      primary_circle_id: id,
      acronym: "Fac #{acronym || title}"
    )
  end

  def self.collection
   Circle.all.map { |c| [c.title, c.id] }
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

  # TODO: Turn all these html_data methods into helper methods
  # (since they're not logically linked to circle.rb and we need them in at least two views)
  def init_circles_html_data(with_sc_roles = true)
    circles_data_hash = circle_to_hash
    html_data = [
      {
        tag: 'div',
        class: 'circle-0'
      },
      {
        tag: 'a',
        path: 'circle_path',
        path_target: self
      },
      {
        tag: 'div',
        class: 'circle-title-container'
      },
      {
        tag: 'h2',
        class: 'circle-title',
        inner_text: title.to_s
      },
      { tag: '/h2' },
      { tag: '/div' },
      { tag: '/a' }
    ]

    # subcircles (with or without roles)
    # TODO: create all these methods
    if with_sc_roles
      html_data << Circle.create_sub_circles_html_data({ data: circle_to_hash })
    else
      html_data << Circle.create_sub_circles_html_data({ data: circle_to_hash, without_roles: true })
    end

    # roles
    # TODO: create this method
    html_data << Circle.create_roles_html_data(roles)
    html_data << { tag: '/div' }
    html_data.flatten
    html_data
  end

  def init_circles_html(with_sc_roles = true)
    # TODO: find solution s.t. html is created in the view
    # circles = Circle.all
    # TODO: find most outer circle by more general attribute like 'level'
    # gcc = circles.find_by(acronym: 'GCC')
    circles_data_hash = circle_to_hash
    "<div class='circle-0'>\n
      <a href='/circles/#{id}'>\n
        <div class='circle-title-container'>\n
          <h2 class='circle-title'>#{title}</h2>\n
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

  def self.create_sub_circles_html_data(args)
    html_data = []
    data = args[:data]
    # TODO: is this guard clause necessary?
    return unless data

    data[:sub_circles].each do |sc_hash|
      sc = sc_hash[:circle]
      html_data << [
        { tag: 'div', class: 'subcircle' },
        { tag: 'a', path: 'circle_path', path_target: sc },
        { tag: 'div', class: 'circle-title-container' },
        { tag: 'h2', class: 'circle-title', inner_text: sc.title.to_s },
        { tag: '/h2' },
        { tag: '/a' }
      ]
      html_data << Circle.create_sub_circles_html_data(sc_hash) if sc_hash
      html_data << Circle.create_roles_html_data(sc.roles) unless args[:with_roles]
      html_data << [
        { tag: '/div' },
        { tag: '/div' }
      ]
    end
    html_data.flatten
    html_data
  end

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

  def self.create_roles_html_data(roles)
    html_data = []
    roles = roles.sort_by(&:title)
    # TODO: migrate r.acronym and use it here instead of title if possible
    roles.each do |r|
      html_data << [
        { tag: 'div', class: "role #{'circle-role' if r.circle_role?}" },
        { tag: 'a', path: 'role_path', path_target: r },
        { tag: 'div', class: 'd-flex-center h-100 mw-100' },
        { tag: 'p', class: 'role-title', inner_text: (r.acronym || r.title).to_s },
        { tag: '/p' },
        { tag: '/div' },
        { tag: '/a' },
        { tag: '/div' }
      ]
    end
    html_data.flatten
    html_data
  end

  def self.create_roles_html(roles)
    html = ""
    roles = roles.sort_by(&:title)
    # TODO: migrate r.acronym and use it here instead of title if possible
    roles.each do |r|
      html += "
        <div class='role #{'circle-role' if r.circle_role?}'>\n
          <a href='/roles/#{r.id}'>\n
            <div class='d-flex-center h-100 mw-100'>\n
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
