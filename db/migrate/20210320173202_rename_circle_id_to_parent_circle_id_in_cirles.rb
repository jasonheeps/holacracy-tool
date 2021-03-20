class RenameCircleIdToParentCircleIdInCirles < ActiveRecord::Migration[6.0]
  def change
    rename_column :circles, :circle_id, :parent_circle_id
  end
end
