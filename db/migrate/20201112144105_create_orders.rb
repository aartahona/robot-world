class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :buyer_dni
      t.string :buyer_name
      t.string :status
      t.decimal :final_price
      t.references :car, null: false, foreign_key: true

      t.timestamps
    end
  end
end
