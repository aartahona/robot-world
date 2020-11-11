class AddColumnStockToCarModel < ActiveRecord::Migration[6.0]
  def change
    add_column :car_models, :stock, :integer
  end
end
