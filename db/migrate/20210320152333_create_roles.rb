class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :title
      t.boolean :is_link
      t.boolean :is_elected

      t.timestamps
    end
  end
end
