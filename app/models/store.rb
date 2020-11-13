class Store < ApplicationRecord
  belongs_to :car

  validates :car, presence: true, uniqueness: true
  validate :car_id, :car_completed, on: :create


  def self.get_store_cars
    cars =[]

    self.all.each do |car|
      car = Car.find_by(id: car.car_id )
      cars << car
    end

    return cars
  end
end
