class Shift < ApplicationRecord
  belongs_to :role_filling

  validates :weekday, :time_start, :time_end, :valid_from,
            presence: { message: 'cannot be blank' }
  validate :shifts_cannot_overlap, :start_cannot_exceed_end

  scope :in_range, (lambda do |range|
    where(
      '(time_start >= :start AND time_start < :end OR
       time_end > :start AND time_end <= :end OR
       time_start <= :start AND time_end >= :end)',
      { start: range.first, end: range.last }
    )
  end)
  scope :exclude_self, ->(id) { where.not(id: id) }
  scope :on_day, ->(day) { where(weekday: day) }
  scope :valid_at, (lambda do |date|
    where(
      '(valid_from <= :date AND (valid_until >= :date OR valid_until = NULL))',
      { date: date }
    )
  end)

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
    Employee.find_by_id(role_filling.employee.id)
  end

  def role
    Role.find_by_id(role_filling.role.id)
  end

  private

  # TODO: this is NOT working properly. includes shifts from other employees (and possibly more bugs)
  def shifts_cannot_overlap
    # day = weekday
    # shifts = employee.shifts.exclude_self(id).where(weekday: day)
    range = Range.new(time_start, time_end)
    # shifts = employee.shifts.exclude_self(id).on_day(weekday).valid_at(valid_from)
    # overlaps = shifts.in_range(range)
    overlaps = employee.shifts.exclude_self(id).on_day(weekday).valid_at(valid_from).in_range(range)
    overlap_error unless overlaps.empty?
  end

  def start_cannot_exceed_end
    start_exceeds_end_error if time_start > time_end
  end

  def overlap_error
    errors.add(:overlap_error, 'There is already a shift scheduled during this time!')
  end

  def start_exceeds_end_error
    errors.add(:start_exceeds_end_error, 'The shift begins after it ends')
  end
end
