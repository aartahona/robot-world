class Factory < ApplicationRecord
  belongs_to :car

  validates :car, presence: true, uniqueness: true

  #Get the defective Cars
  def self.defective_cars
    defective_cars = []

    self.all.each do |car|
      car = Car.find_by(id: car.car_id )
      defective_cars << car if car.defective_parts.any?
    end
    return defective_cars
  end

  #Get the ready to sell Cars
  def self.good_condition_cars
    good_cars = []

    self.all.each do |car|
      car = Car.find_by(id: car.car_id )
      good_cars << car if car.defective_parts.empty? 
      #good_cars << car if car.defective_parts.any?
    end
    return good_cars
  end
  
  def self.add_car(car)
    begin
      if(!Factory.create(car_id: car.id))
          puts "An error has ocurred creating the car"
          puts self.errors.full_messages
      end
    rescue StandardError => e
        puts e
    end
  end

end
