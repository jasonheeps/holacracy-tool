class Circle < ApplicationRecord
  has_many :roles, foreign_key: 'primary_circle_id'
  has_many :role_fillings, through: :roles
  has_many :employees, through: :role_fillings
  has_many :shifts, through: :role_fillings
  belongs_to :super_circle, class_name: 'Circle', foreign_key: 'super_circle_id', optional: true
  has_many :accountabilities, class_name: 'CircleAccountability', dependent: :destroy

  def roles_unique
    roles.uniq.sort_by(&:title)
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

  def roles_count_total
    count = roles.to_a.count
    sub_circles.each do |sc|
      count += sc.roles_count_total
    end
    count
  end

  private

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
