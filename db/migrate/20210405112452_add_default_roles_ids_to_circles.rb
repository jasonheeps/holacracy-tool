class AddDefaultRolesIdsToCircles < ActiveRecord::Migration[6.0]
  def change
    add_column :circles, :lead_link_role_id, :bigint
    add_column :circles, :rep_link_role_id, :bigint
    add_column :circles, :secretary_role_id, :bigint
    add_column :circles, :facilitator_role_id, :bigint
  end
end
