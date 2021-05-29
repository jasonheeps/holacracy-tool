class AddUrlToRoles < ActiveRecord::Migration[6.0]
  def change
    add_column :roles, :url, :string
  end
end
