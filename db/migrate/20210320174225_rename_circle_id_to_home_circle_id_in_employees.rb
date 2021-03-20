class RenameCircleIdToHomeCircleIdInEmployees < ActiveRecord::Migration[6.0]
  def change
    rename_column :employees, :circle_id, :home_circle_id
  end
end
