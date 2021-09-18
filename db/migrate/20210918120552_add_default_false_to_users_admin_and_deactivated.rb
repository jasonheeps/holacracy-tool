class AddDefaultFalseToUsersAdminAndDeactivated < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :admin, :boolean, default: false
    change_column :users, :deactivated, :boolean, default: false
  end
end
