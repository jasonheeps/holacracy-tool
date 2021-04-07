class RemoveCircleIdFromEmployees < ActiveRecord::Migration[6.0]
  def change
    remove_column :employees, :circle_id
  end
end
