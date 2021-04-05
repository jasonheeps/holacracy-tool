class Role < ApplicationRecord
  has_many :circle_roles, dependent: :destroy
  has_many :circles, through: :circle_roles

  has_many :employee_roles, dependent: :destroy
  has_many :employees, through: :employee_roles

  def ccms
    employee_roles_to_employees(employee_roles.where(role_id: id, is_ccm: true))
  end

  # all employees who fill a role as non-ccm, i.e. neither as ccm nor as substitute
  def non_ccms
    employee_roles_to_employees(employee_roles.where(role_id: id, is_ccm: false, is_substitute: false))
  end

  def substitutes
    employee_roles_to_employees(employee_roles.where(role_id: id, is_substitute: true))
  end

  def ccms_and_non_ccms
    ccms + non_ccms
  end

  def default_role?
    is_lead_link || is_rep_link || is_cross_link || is_facilitator || is_secretary
  end

  def link?
    is_lead_link || is_rep_link || is_cross_link
  end

  def elected?
    is_rep_link || is_facilitator || is_secretary
  end

  def main_circle
    main_circle_id = circle_roles.find_by(role_id: id, is_main_circle: true).circle_id
    Circle.find_by_id(main_circle_id)
  end

  private

  def employee_roles_to_employees(employee_roles)
    employee_roles.map { |er| employees.find_by_id(er.employee_id) }
  end
end
