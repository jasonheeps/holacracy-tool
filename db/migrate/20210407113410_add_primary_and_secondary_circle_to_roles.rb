class AddPrimaryAndSecondaryCircleToRoles < ActiveRecord::Migration[6.0]
  def change
    add_reference :roles, :primary_circle, index: true, foreign_key: {to_table: :circles}
    add_reference :roles, :secondary_circle, index: true, foreign_key: {to_table: :circles}
  end
end
