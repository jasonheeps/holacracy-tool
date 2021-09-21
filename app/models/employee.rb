class Employee < ApplicationRecord
  has_one_attached :photo
  belongs_to :user

  has_many :role_fillings, class_name: 'RoleFilling', dependent: :destroy
  has_many :roles, through: :role_fillings
  # has_many :shifts, through: :role_fillings, dependent: :destroy
  # has_many :circles, through: :roles

  include PgSearch::Model
  pg_search_scope :search_by_name_and_nickname,
                  against: %i[first_name last_name nickname],
                  using: {
                    tsearch: { prefix: true }
                  }

  scope :ordered_by_first_name, -> { order(first_name: :asc) }
  # NOTE: in 'join(:user)' 'user' is singular and refers to 'belongs_to :user'
  #       in 'where(users:' 'users' is plural and refers to the table in the db 
  scope :with_activated_account, -> { joins(:user).where(users: { deactivated: false }) }

  def roles_sorted
    roles.ordered_by_title
  end

  def roles_in(circle)
    roles.in_circle(circle).ordered_by_title
  end

  def circles
    circles = []
    roles.each do |r|
      pc = r.primary_circle
      role_circles = [pc]
      role_circles << r.secondary_circle if r.secondary_circle
      role_circles.each do |c|
        circles << c unless circles.include?(c)
      end
    end
    circles.sort_by(&:title)
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

  def self.collection
    collection = Employee.ordered_by_first_name.map { |e| [e.nickname || e.full_name, e.id] }
  end

  # these inputs give the same result:
  # :monday, 'monday', 0
  def shifts_on(weekday)
    shifts.where(weekday: weekday)
  end
end
