class CreateEmployeeRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :employee_roles do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
      t.boolean :is_ccm

      t.timestamps
    end
  end
end
