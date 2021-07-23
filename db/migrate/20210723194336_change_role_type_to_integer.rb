class ChangeRoleTypeToInteger < ActiveRecord::Migration[6.0]
  def change
    remove_column :roles, :role_type
    add_column :roles, :role_type, :integer
  end
end
