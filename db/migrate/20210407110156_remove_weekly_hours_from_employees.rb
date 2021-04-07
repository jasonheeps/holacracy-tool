class RemoveWeeklyHoursFromEmployees < ActiveRecord::Migration[6.0]
  def change
    remove_column :employees, :weekly_hours
  end
end
