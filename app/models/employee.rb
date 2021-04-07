class Employee < ApplicationRecord
  belongs_to :user

  has_many :role_fillings, dependent: :destroy
  has_many :roles, through: :role_fillings
  # has_many :circle_roles, through: :roles
  # has_many :circles, through: :circle_roles
  has_many :circles, through: :roles

  # def home_circle
  #   Circle.find_by_id(home_circle_id)
  # end

  def ccm?(role)
    # role_fillings.find_by(employee_id: id, role_id: role.id).is_ccm
    role_fillings.find_by(employee_id: id, role_id: role.id, status: 'ccm')
  end

  def non_ccm?(role)
    # er = role_fillings.find_by(employee_id: id, role_id: role.id)
    # !(er.is_ccm || er.is_substitute)
    role_fillings.find_by(employee_id: id, role_id: role.id, status: 'non-ccm')
  end

  def substitute?(role)
    role_fillings.find_by(employee_id: id, role_id: role.id, status: 'substitute')
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    (first_name[0] + last_name[0]).upcase
  end
end
