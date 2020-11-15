class CreateExchangeOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :exchange_orders do |t|
      t.references :order, null: false, foreign_key: true
      t.string :wanted_model
      t.string :status

      t.timestamps
    end
  end
end
