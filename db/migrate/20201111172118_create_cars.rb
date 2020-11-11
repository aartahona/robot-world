class CreateCars < ActiveRecord::Migration[6.0]
  def change
    create_table :cars do |t|
      t.string :stage
      t.boolean :completed
      t.references :car_model, null: false, foreign_key: true

      t.timestamps
    end
  end
end
