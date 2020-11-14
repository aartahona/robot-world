class Factory < ApplicationRecord
  DEFECTIVE_PROBABILITY = 50.freeze
  TYPES = ["wheel", "chassis", "laser", "computer", "engine", "seat"].freeze

  belongs_to :car
  validates :car, presence: true, uniqueness: true

    
  #Get an array of the cars stored in the warehouse
  def self.get_warehouse_cars
    cars =[]
    
    self.all.each do |car|
      car = Car.find_by(id: car.car_id )
      cars << car
    end
    return cars
  end

  #TODO move logic to car model
  #Get an array of the defective Cars
  def self.defective_cars
    defective_cars = []

    self.all.each do |car|
      car = Car.find_by(id: car.car_id )
      defective_cars << car if car.defective_parts.any?
    end
    return defective_cars
  end

  #Get an array of the ready to sell Cars
  def self.good_condition_cars
    good_cars = []

    self.all.each do |car|
      car = Car.find_by(id: car.car_id )
      good_cars << car if car.defective_parts.empty? 
    end
    return good_cars
  end

  #Find how many stock the warehouse has by searching with the name of the model
  def self.get_stock_by_name(model_name)
    stock = 0

    self.all.each do |car|
      stock+=1 if Car.find_by( id: car.car_id ).car_model.name == model_name
    end
    return stock
  end

  #Find how many stock of a model the warehouse has by searching with the id of the model
  def self.get_stock_by_id(model_id)
    stock = 0
    
    self.all.each do |car|
      stock+=1 if Car.find_by( id: car.car_id ).car_model.id == model_id
    end
    return stock
  end

  #Adds the record of a new car that entered the warehouse stock
  def self.add_car_to_warehouse(car)
    Factory.create(car_id: car.id)
  end

  #Removes a car from the warehouse
  def self.remove_car_from_warehouse(car)
    Factory.find_by(car_id: car.id).destroy
  end

  #Adds the wheels and the engine to an empty car
  def self.basic_structure(car)
    if car.status == "empty"
      4.times { car.parts << Part.create(name: "wheel", defective: random_defective(), car_id: car.id) }
      car.parts << Part.create(name: "engine", defective: random_defective(), car_id: car.id)
      car.status = "basic_structure"
      car.save
    end
    return car
  end

  #Adds the computer and the laser to a car
  def self.electronic_devices(car)
    if car.status == "basic_structure"
      car.parts << Part.create(name: "computer", defective: random_defective(), car_id: car.id)
      car.parts << Part.create(name: "laser", defective: random_defective(), car_id: car.id)
      car.status = "electronic_devices"
      car.save
    end
    return car
  end

  #Finishes the chassis and seats of the car
  def self.painting_final_details(car)
    if car.status == "electronic_devices"
      car.parts << Part.create(name: "chassis", defective: random_defective(), car_id: car.id)
      2.times { car.parts << Part.create(name: "seat", defective: random_defective(), car_id: car.id) }
      car.status = "final_details"
      car.save
    end
    return car
  end

  #Sets the car as completed and saves it to the warehouse
  def self.set_car_as_completed(car)
    if car.status == "final_details"
      car.status = "finished"
      car.completed = true
      car.save
      self.add_car_to_warehouse(car)
    end
  end

  #Sets the car as ready to sell
  def self.set_car_as_ready_to_sell(car)
    if car.completed && car.status == "finished"
      car.status = "ready_to_sell"
      car.save
    end
  end

  #Sets the car as defective
  def self.set_car_as_defective(car)
    if car.completed && car.status == "finished"
      car.status = "defective"
      car.save
    end
  end

  #Creates a new car without structue
  #Checks wich models have stocks to be assigned to the new car
  def self.create_random_empty_car
    model = CarModel.all.with_stock.sample
    Car.create_empty_car(model.id)
  end

  def self.random_defective
    rand(DEFECTIVE_PROBABILITY) == 0
  end

end
