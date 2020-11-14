class Order < ApplicationRecord
  belongs_to :car

  validates :buyer_dni, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :car, presence: true, uniqueness: true
  validates :final_price, numericality: { greater_than: 0 }
  validate :car_id, :car_completed, on: :create

  #validate Car is completed
  def car_completed
    errors.add(:car_id, "This car is not completed") if Car.find_by( id: self.car_id).completed != true
  end

  def self.place_an_order(car, buyer_dni, buyer_name, order_status, price)
    Order.create(buyer_dni: buyer_dni, buyer_name: buyer_name, car_id: car.id, status: order_status, final_price: price)
  end

end
