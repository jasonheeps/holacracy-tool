class Role < ApplicationRecord
  has_many :circle_roles, dependent: :destroy
  has_many :circles, through: :circle_roles

  has_many :employee_roles, dependent: :destroy
  has_many :employees, through: :employee_roles
end
