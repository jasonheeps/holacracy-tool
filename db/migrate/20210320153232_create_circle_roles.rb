class CreateCircleRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :circle_roles do |t|
      t.references :circle, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
