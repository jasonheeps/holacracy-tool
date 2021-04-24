class ChangeStatusToEnumInRoleFillings < ActiveRecord::Migration[6.0]
  def change
    remove_column :role_fillings, :status
    add_column :role_fillings, :role_filling_status, :integer
  end
end
