class ChangeSecondaryCircleToNull < ActiveRecord::Migration[6.0]
  def change
    change_column :roles, :secondary_circle_id, :bigint, null: true
  end
end
