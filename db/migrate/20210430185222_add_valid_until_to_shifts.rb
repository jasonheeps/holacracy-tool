class AddValidUntilToShifts < ActiveRecord::Migration[6.0]
  def change
    add_column :shifts, :valid_until, :date
  end
end
