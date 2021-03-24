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
end
