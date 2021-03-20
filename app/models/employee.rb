class Employee < ApplicationRecord
  belongs_to :user

  has_many :employee_roles, dependent: :destroy
  has_many :roles, through: :employee_roles
  has_many :circle_roles, through: :roles
  has_many :circles, through: :circle_roles

  def home_circle
    Circle.find_by_id(home_circle_id)
  end
end
