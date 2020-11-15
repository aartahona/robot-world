class AddColumnReturnsToOrderModel < ActiveRecord::Migration[6.0]
  def change
    add_column :order, :returns_limit, :integer
  end
end
