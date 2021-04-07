class ChangeSuperCircleNullToTrue < ActiveRecord::Migration[6.0]
  def change
    change_column :circles, :super_circle_id, :bigint, null: true
  end
end
