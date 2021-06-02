class Employee < ApplicationRecord
  has_one_attached :photo
  belongs_to :user

  has_many :role_fillings, class_name: 'RoleFilling', dependent: :destroy
  has_many :roles, through: :role_fillings
  has_many :shifts, through: :role_fillings, dependent: :destroy
  has_many :circles, through: :roles

  # def home_circle
  #   Circle.find_by_id(home_circle_id)
  # end

  def self.all_sorted
    Employee.all.sort_by(&:first_name)
  end

  def ccm?(role)
    !role_fillings.find_by(role_id: role.id, role_filling_status: :ccm).nil?
  end

  def non_ccm?(role)
    !role_fillings.find_by(role_id: role.id, role_filling_status: :non_ccm).nil?
  end

  def substitute?(role)
    !role_fillings.find_by(role_id: role.id, role_filling_status: :substitute).nil?
  end

  def status(role)
    role_fillings.find_by(role_id: role.id).role_filling_status
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    (first_name[0] + last_name[0]).upcase
  end

  def shifts_sorted
    shifts.sort_by(&:weekday)
  end

  # these inputs give the same result:
  # :monday, 'monday', 0
  def shifts_on(weekday)
    shifts.where(weekday: weekday)
  end
end
