class Store < ApplicationRecord
  belongs_to :car

  validates :car, presence: true, uniqueness: true
  validate :car_id, :car_completed, on: :create

  #validate Car is completed
  def car_completed
    errors.add(:car_id, "This car is not completed") if Car.find_by( id: self.car_id).completed != true
  end
end
