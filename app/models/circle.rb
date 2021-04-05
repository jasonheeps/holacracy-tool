class Circle < ApplicationRecord
  has_many :accountabilities, dependent: :destroy
  has_many :policies, dependent: :destroy
  has_many :domains, dependent: :destroy
  has_many :circle_roles
  has_many :roles, through: :circle_roles
  has_many :employee_roles, through: :roles
  has_many :employees, through: :employee_roles

  def parent_circle
    Circle.find_by_id(parent_circle_id)
  end

  def sub_circles
    Circle.where(parent_circle_id: id)
  end

  def lead_link
    Role.find(lead_link_role_id).employees.first if lead_link_role_id
  end

  def rep_link
    Role.find(rep_link_role_id).employees.first if lead_link_role_id
  end

  def facilitator
    Role.find(facilitator_role_id).employees.first if lead_link_role_id
  end

  def secretary
    Role.find(secretary_role_id).employees.first if lead_link_role_id
  end

  def cross_link(circle)
  end

  # GCC has level 0
  # subcircles of GCC have level 1
  # subcircles of subcircles of GCC have level 2
  # and so on...
  def level(circle = self)
    return 0 unless circle.parent_circle_id

    1 + level(circle.parent_circle)
  end
end
