class Order < ApplicationRecord
  belongs_to :car

  validates :buyer_dni, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :car, presence: true, uniqueness: true
  validates :final_price, numericality: { greater_than: 0 }
  validates :returns_limit, presence: true, numericality: { only_integer: true, greater_than_or_equal: 0 }
  validate :car_id, :car_completed, on: :create

  #validate Car is completed
  def car_completed
    errors.add(:car_id, "This car is not completed") if Car.find_by( id: self.car_id).completed != true
  end

  #Method to place a new order
  def self.place_an_order(car, buyer_dni, buyer_name, order_status, price, returns)
    Order.create(buyer_dni: buyer_dni, buyer_name: buyer_name, car_id: car.id, status: order_status, final_price: price, returns_limit: returns)
  end

  #Changes the existing car of the order with the new car
  def exchange_car(car)
    if self.car.car_model.name != car.car_model.name
      self.car_id = car.id
      self.final_price = car.car_model.price
      self.returns_limit -= 1
      self.save
    end
  end

  def set_as_completed
    self.status = "completed"
    self.save
  end

  def set_as_cancelled
    self.status = "cancelled"
    self.save
  end
end
