class CreateCircleAccountabilities < ActiveRecord::Migration[6.0]
  def change
    create_table :circle_accountabilities do |t|
      t.references :circle, null: false, foreign_key: true
      t.text :content
    end
  end
end
