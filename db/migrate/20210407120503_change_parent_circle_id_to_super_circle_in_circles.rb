class ChangeParentCircleIdToSuperCircleInCircles < ActiveRecord::Migration[6.0]
  def change
    remove_column :circles, :parent_circle_id
    add_reference :circles, :super_circle, index: true, foreign_key: {to_table: :circles}
  end
end
