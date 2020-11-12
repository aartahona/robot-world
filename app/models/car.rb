class Car < ApplicationRecord
  belongs_to :car_model
  has_many :parts

  validates :car_model, presence: true
  validate :car_model, :car_model_stock, on: :create

  scope :completed_cars, -> { where("completed = ?", true) }

#validate if there is a stock for the model
  def car_model_stock
      errors.add(:car_model, "There is no stock of this model") if CarModel.find_by( id: self.car_model_id).stock <= 0
  end

#Get the defective parts of a Car
  def defective_parts
    defective_parts = []

    self.parts.each do |part|
      defective_parts << part if part.defective
    end
    return defective_parts
  end

#Creates a new car with random model
#Used for debugging
  def self.create_random_car
    random_car = Car.new
    random_car.completed = false
    random_car.car_model_id = CarModel.with_stock.sample.id
    
    begin
        if(!random_car.save)
            puts "An error has ocurred creating the car"
            puts self.errors.full_messages
        end
    rescue StandardError => e
        puts e
    end
  end
end
