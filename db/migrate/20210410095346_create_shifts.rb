class CreateShifts < ActiveRecord::Migration[6.0]
  def change
    create_table :shifts do |t|
      t.references :role_filling, null: false, foreign_key: true
      t.string :weekday
      t.time :time_start
      t.time :time_end
      t.date :valid_from

      t.timestamps
    end
  end
end
