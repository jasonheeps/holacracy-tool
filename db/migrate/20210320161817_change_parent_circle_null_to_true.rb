class ChangeParentCircleNullToTrue < ActiveRecord::Migration[6.0]
  def change
    change_column :circles, :circle_id, :bigint, null: true
  end
end
