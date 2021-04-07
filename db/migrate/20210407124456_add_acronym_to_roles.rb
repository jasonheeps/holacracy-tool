class AddAcronymToRoles < ActiveRecord::Migration[6.0]
  def change
    add_column :roles, :acronym, :string
  end
end
