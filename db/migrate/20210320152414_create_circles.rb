class CreateCircles < ActiveRecord::Migration[6.0]
  def change
    create_table :circles do |t|
      t.string :title
      t.string :abbreviation
      t.references :circle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
