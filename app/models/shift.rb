class Shift < ApplicationRecord
  belongs_to :role_filling

  enum weekday: {
    monday: 0,
    tuesday: 1,
    wednesday: 2,
    thursday: 3,
    friday: 4,
    saturday: 5,
    sunday: 6
  }

  def employee
    id = RoleFilling.find_by_id(role_filling_id).employee_id
    Employee.find_by_id(id)
  end

  def role
    id = RoleFilling.find_by_id(role_filling_id).role_id
    Role.find_by_id(id)
  end
end
