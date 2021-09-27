class Role < ApplicationRecord
  # has_many :circle_roles, dependent: :destroy
  # has_many :circles, through: :circle_roles
  belongs_to :primary_circle, class_name: 'Circle', foreign_key: 'primary_circle_id'
  belongs_to :secondary_circle, class_name: 'Circle', foreign_key: 'secondary_circle_id', optional: true

  has_many :role_fillings, dependent: :destroy
  has_many :shifts, through: :role_fillings, dependent: :destroy
  has_many :employees, through: :role_fillings

  validates :role_type, presence: { message: 'Wähle den Rollentyp' } 

  enum role_type: {
    ll: 0,
    rl: 1,
    fac: 2,
    sec: 3,
    cl: 4,
    custom: 5
  }

  include PgSearch::Model
  pg_search_scope :search_by_title_and_acronym,
                  against: %i[title acronym],
                  using: {
                    tsearch: { prefix: true }
                  }
  

  scope :ordered_by_title, -> { order(title: :asc) } 
  scope :in_circle, ->(circle) { where('primary_circle_id = ?', circle) }

  def circles
    circles = [primary_circle]
    circles << secondary_circle if secondary_circle
    circles
  end

  def ccms
    role_fillings_to_employees(role_fillings.where(role_id: id, role_filling_status: RoleFilling.role_filling_statuses[:ccm]))
  end

  # all employees who fill a role as non-ccm, i.e. neither as ccm nor as substitute
  def non_ccms
    # role_fillings_to_employees(role_fillings.where(role_id: id, is_ccm: false, is_substitute: false))
    role_fillings_to_employees(role_fillings.where(role_id: id, role_filling_status: RoleFilling.role_filling_statuses[:non_ccm]))
  end

  def substitutes
    role_fillings_to_employees(role_fillings.where(role_id: id, role_filling_status: RoleFilling.role_filling_statuses[:substitute]))
  end

  def ccms_and_non_ccms
    ccms + non_ccms
  end

  def circle_role?
    %w[ll rl cl fac sec].include?(role_type)
  end

  # checks whether the role is lead link, rep link or cross link
  # def link?
  #   return false if role_type.blank?
  #
  #   %w[ll rl cl].include?(role_type.to_sym)
  # end

  # def elected?
  #   %w[rl fac sec].include?(role_type)
  # end

  def custom?
    role_type == :custom.to_s
  end

  def cross_link?
    role_type == :cl.to_s
  end

  def destroyable?
    # not destroyable are: ll, rl, sec, fac
    custom? || cross_link?
  end

  # TODO: move this to role_filling.rb
  def status_string(employee)
    status = role_fillings.find_by(employee_id: employee.id).role_filling_status
    case status
    when :ccm
      return "CCM"
    when :non_ccm
      return "NON-CCM"
    when :substitute
      return "Vertretung"
    end
  end

  # TODO: return the employee responsible for this role, even if it's not filled
  def role_filler
    # employees || self.primary_circle.lead_link.to_a || ... 
  end

  def self.collection
   Role.all.map { |r| [r.title, r.id] }
  end

  # is now 'primary_circle'
  # def main_circle
  #   main_circle_id = circle_roles.find_by(role_id: id, is_main_circle: true).circle_id
  #   Circle.find_by_id(main_circle_id)
  # end

  private

  def role_fillings_to_employees(role_fillings)
    role_fillings.map { |rf| employees.find_by_id(rf.employee_id) }.uniq
  end
end
