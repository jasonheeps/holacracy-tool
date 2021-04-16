class Employee < ApplicationRecord
  belongs_to :user

  has_many :role_fillings, class_name: 'RoleFilling', dependent: :destroy
  has_many :roles, through: :role_fillings
  has_many :shifts, through: :role_fillings, dependent: :destroy
  has_many :circles, through: :roles

  # def home_circle
  #   Circle.find_by_id(home_circle_id)
  # end

  def ccm?(role)
    role_fillings.find_by(employee_id: id, role_id: role.id, status: 'ccm')
  end

  def non_ccm?(role)
    role_fillings.find_by(employee_id: id, role_id: role.id, status: 'non-ccm')
  end

  def substitute?(role)
    role_fillings.find_by(employee_id: id, role_id: role.id, status: 'substitute')
  end

  def status(role)
    role_fillings.find_by(role_id: role.id).status
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    (first_name[0] + last_name[0]).upcase
  end
end
