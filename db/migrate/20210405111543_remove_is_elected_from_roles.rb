class RemoveIsElectedFromRoles < ActiveRecord::Migration[6.0]
  def change
    remove_column :roles, :is_elected
  end
end
