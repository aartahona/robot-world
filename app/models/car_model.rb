class CarModel < ApplicationRecord
    has_many :cars

    validates :name, :year, presence: true
    validates :price, :cost_price, numericality: { greater_than: 0 }
    validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal: 0 }

    scope :with_stock, -> { where("stock > ?", 0) }

#Methods to increase and decrease the stock of a model based of an amount
    def increase_stock(amount)
        self.stock+=amount
        self.save
    end

    def decrease_stock(amount)
        self.stock-=amount
        self.save
    end
end
