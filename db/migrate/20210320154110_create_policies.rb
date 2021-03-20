class CreatePolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :policies do |t|
      t.text :content
      t.references :circle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
