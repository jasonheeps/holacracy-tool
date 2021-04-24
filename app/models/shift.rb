class Shift < ApplicationRecord
  belongs_to :role_filling

  validates :weekday, :time_start, :time_end, :valid_from,
            presence: { message: 'cannot be blank' }
  validate :shifts_cannot_overlap

  scope :in_range, (lambda do |range|
    where(
      '(time_start > :start AND time_start < :end OR time_end > :start AND time_end < :end)',
      { start: range.first, end: range.last }
    )
  end)
  scope :exclude_self, ->(id) { where.not(id: id) }

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

  private

  def shifts_cannot_overlap
    range = Range.new(time_start, time_end)
    overlaps = Shift.exclude_self(id).in_range(range)
    overlap_error unless overlaps.empty?
  end

  def overlap_error
    errors.add(:overlap_error, 'There is already a shift scheduled during this time!')
  end
end
