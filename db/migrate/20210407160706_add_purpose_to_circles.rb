class AddPurposeToCircles < ActiveRecord::Migration[6.0]
  def change
    add_column :circles, :purpose, :text
  end
end
