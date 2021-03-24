class RemoveHomeCircleFromEmployees < ActiveRecord::Migration[6.0]
  def change
    remove_column :employees, :home_circle_id
  end
end
