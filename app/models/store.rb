class Store < ApplicationRecord
  belongs_to :car

  validates :car, presence: true, uniqueness: true
  validate :car_id, :car_ready_to_sell, on: :create


  #Validates if the car is rady to be sold
  def car_ready_to_sell
    self.car.status == "ready_to_sell" && self.car.completed == true ? true : errors.add(:car_id, "This car is not ready to be sold")
  end

  #Get an array of cars available in the Store
  def self.get_store_cars
    cars =[]

    self.all.each do |car|
      car = Car.find_by(id: car.car_id )
      cars << car
    end

    return cars
  end

  #Adds the record of a new car that entered the Store stock
  def self.add_car_to_store(car)
    Store.create(car_id: car.id)
  end

  #Removes a car from the Store stock
  def self.remove_car_from_store(car)
    Store.find_by(car_id: car.id).destroy
  end

  #Find how many stock the Store has by searching with the name of the model
  def self.get_stock_by_name(model_name)
    stock = 0

    self.all.each do |car_store|
      #stock+=1 if Car.find_by( id: car.car_id ).car_model.name == model_name
      stock+=1 if car_store.car.car_model.name == model_name
    end
    return stock
  end

  #Find how many stock the Store has by searching with the name of the model
  def self.get_stock_by_model_id(model_id)
    stock = 0

    self.all.each do |car_store|
      #stock+=1 if Car.find_by( id: car.car_id ).car_model.name == model_name
      stock+=1 if car_store.car.car_model.id == model_id
    end
    return stock
  end

  #Return an array of all available cars of a specific model id
  def self.get_cars_by_model_id(model_id)
    cars =[]

    self.all.each do |car|
      car = Car.find_by(id: car.car_id)
      cars << car if car.car_model.id = model_id
    end

    return cars
  end

  #Sets the car as ready to sell
  def self.set_car_as_sold(car)
    if car.completed && car.status == "ready_to_sell"
      car.status = "sold"
      car.save
    end
  end
end
