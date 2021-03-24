class CreateShifts < ActiveRecord::Migration[6.0]
  def change
    create_table :shifts do |t|
      t.references :employee_role, null: false, foreign_key: true
      t.integer :weekday
      t.time :time_start
      t.time :time_end
      t.date :valid_from
      t.date :valid_until
    end
  end
end
