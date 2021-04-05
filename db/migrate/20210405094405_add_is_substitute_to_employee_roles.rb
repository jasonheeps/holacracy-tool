class AddIsSubstituteToEmployeeRoles < ActiveRecord::Migration[6.0]
  def change
    add_column :employee_roles, :is_substitute, :boolean
  end
end
