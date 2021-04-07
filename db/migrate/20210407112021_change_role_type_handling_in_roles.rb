class ChangeRoleTypeHandlingInRoles < ActiveRecord::Migration[6.0]
  def change
    remove_columns :roles,
      :is_lead_link,
      :is_rep_link,
      :is_cross_link,
      :is_facilitator,
      :is_secretary
    add_column :roles, :role_type, :string
  end
end
