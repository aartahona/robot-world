class CarModel < ApplicationRecord
    validates :name, :year, presence: true
    validates :price, :cost_price, numericality: { greater_than: 0 }
    validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal: 0 }

    has_many :cars
end
