class Circle < ApplicationRecord
  # has_many :circle_roles
  # has_many :roles, through: :circle_roles
  has_many :roles, foreign_key: 'primary_circle_id'
  has_many :role_fillings, through: :roles
  has_many :employees, through: :role_fillings
  belongs_to :super_circle, class_name: 'Circle', foreign_key: 'super_circle_id', optional: true
  has_many :accountabilities, class_name: 'CircleAccountability'

  def roles_unique
    roles.uniq
  end

  def employees_unique
    employees.uniq
  end

  # is now 'super_circle' (from active record)
  # def super_circle
  #   Circle.find_by_id(parent_circle_id)
  # end

  def sub_circles
    Circle.where(super_circle_id: id)
  end

  def lead_link
    # Role.find_by(lead_link_role_id).employees.first if lead_link_role_id
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
    # Role.find(rep_link_role_id).employees.first if rep_link_role_id
    rl_role = Role.find_by(role_type: 'rl', primary_circle_id: id)
    # ToDo: remove safety '&'
    rl_role&.ccms&.first
  end

  def facilitator
    # Role.find(facilitator_role_id).employees.first if facilitator_role_id
    fac_role = Role.find_by(role_type: 'fac', primary_circle_id: id)
    # ToDo: remove safety '&'
    fac_role&.ccms&.first
  end

  def secretary
    # Role.find(secretary_role_id).employees.first if secretary_role_id
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
end
