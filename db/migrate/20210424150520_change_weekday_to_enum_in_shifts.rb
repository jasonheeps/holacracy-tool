class ChangeWeekdayToEnumInShifts < ActiveRecord::Migration[6.0]
  def change
    remove_column :shifts, :weekday
    add_column :shifts, :weekday, :integer
  end
end
