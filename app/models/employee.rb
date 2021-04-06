class Employee < ApplicationRecord
  belongs_to :user

  has_many :employee_roles, dependent: :destroy
  has_many :roles, through: :employee_roles
  has_many :circle_roles, through: :roles
  has_many :circles, through: :circle_roles

  # def home_circle
  #   Circle.find_by_id(home_circle_id)
  # end

  def ccm?(role)
    employee_roles.find_by(employee_id: id, role_id: role.id).is_ccm
  end

  def non_ccm?(role)
    er = employee_roles.find_by(employee_id: id, role_id: role.id)
    !(er.is_ccm || er.is_substitute)
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
