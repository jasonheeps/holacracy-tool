class CreateAccountabilities < ActiveRecord::Migration[6.0]
  def change
    create_table :accountabilities do |t|
      t.text :content
      t.references :role, foreign_key: true
      t.references :circle, foreign_key: true

      t.timestamps
    end
  end
end
