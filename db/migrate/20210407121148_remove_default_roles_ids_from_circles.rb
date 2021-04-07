class RemoveDefaultRolesIdsFromCircles < ActiveRecord::Migration[6.0]
  def change
    remove_columns :circles,
      :lead_link_role_id,
      :rep_link_role_id,
      :facilitator_role_id,
      :secretary_role_id
  end
end
