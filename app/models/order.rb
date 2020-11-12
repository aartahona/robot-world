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

end
