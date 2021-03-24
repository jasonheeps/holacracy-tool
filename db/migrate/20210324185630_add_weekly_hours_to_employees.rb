class AddWeeklyHoursToEmployees < ActiveRecord::Migration[6.0]
  def change
    add_column :employees, :weekly_hours, :integer
  end
end
