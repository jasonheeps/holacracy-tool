class AddBooleanForDefaultRolesToRoles < ActiveRecord::Migration[6.0]
  def change
    remove_column :roles, :is_link
    add_column :roles, :is_lead_link, :boolean
    add_column :roles, :is_rep_link, :boolean
    add_column :roles, :is_cross_link, :boolean
    add_column :roles, :is_facilitator, :boolean
    add_column :roles, :is_secretary, :boolean
  end
end
