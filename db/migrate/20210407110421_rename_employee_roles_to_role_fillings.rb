class RenameEmployeeRolesToRoleFillings < ActiveRecord::Migration[6.0]
  def change
    rename_table :employee_roles, :role_fillings
  end
end
