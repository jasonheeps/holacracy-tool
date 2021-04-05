class AddIsMainCircleToCircleRoles < ActiveRecord::Migration[6.0]
  def change
    add_column :circle_roles, :is_main_circle, :boolean, default: true
  end
end
