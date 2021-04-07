class ChangeRoleFillingStatusHandlingInRoleFillings < ActiveRecord::Migration[6.0]
  def change
    remove_column :role_fillings, :is_ccm
    remove_column :role_fillings, :is_substitute
    add_column :role_fillings, :status, :string
  end
end
