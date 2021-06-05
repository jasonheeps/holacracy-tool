class Role < ApplicationRecord
  # has_many :circle_roles, dependent: :destroy
  # has_many :circles, through: :circle_roles

  # TODO: create an enum for 'role_type'

  belongs_to :primary_circle, class_name: 'Circle', foreign_key: 'primary_circle_id'
  belongs_to :secondary_circle, class_name: 'Circle', foreign_key: 'secondary_circle_id', optional: true

  has_many :role_fillings, dependent: :destroy
  has_many :shifts, through: :role_fillings, dependent: :destroy
  has_many :employees, through: :role_fillings

  include PgSearch::Model
  pg_search_scope :search_by_title_and_acronym,
                  against: %i[title acronym],
                  using: {
                    tsearch: { prefix: true }
                  }

  def circles
    circles = [primary_circle]
    circles << secondary_circle if secondary_circle
    circles
  end

  def ccms
    # role_fillings_to_employees(role_fillings.where(role_id: id, is_ccm: true))
    role_fillings_to_employees(role_fillings.where(role_id: id, role_filling_status: :ccm))
  end

  # all employees who fill a role as non-ccm, i.e. neither as ccm nor as substitute
  def non_ccms
    # role_fillings_to_employees(role_fillings.where(role_id: id, is_ccm: false, is_substitute: false))
    role_fillings_to_employees(role_fillings.where(role_id: id, role_filling_status: :non_ccm))
  end

  def substitutes
    # role_fillings_to_employees(role_fillings.where(role_id: id, is_substitute: true))
    role_fillings_to_employees(role_fillings.where(role_id: id, role_filling_status: :substitute))
  end

  def ccms_and_non_ccms
    ccms + non_ccms
  end

  def circle_role?
    %w[ll rl cl fac sec].include?(role_type)
  end

  def link?
    # is_lead_link || is_rep_link || is_cross_link
    %w[ll rl cl].include?(role_type)
  end

  def elected?
    %w[rl fac sec].include?(role_type)
    # is_rep_link || is_facilitator || is_secretary
  end

  def status_string(employee)
    status = role_fillings.find_by(employee_id: employee.id).role_filling_status
    case status
    when "ccm"
      return "CCM"
    when "non_ccm"
      return "NON-CCM"
    when "substitute"
      return "Vertretung"
    end
  end

  # is now 'primary_circle'
  # def main_circle
  #   main_circle_id = circle_roles.find_by(role_id: id, is_main_circle: true).circle_id
  #   Circle.find_by_id(main_circle_id)
  # end

  private

  def role_fillings_to_employees(role_fillings)
    role_fillings.map { |er| employees.find_by_id(er.employee_id) }.uniq
  end
end
