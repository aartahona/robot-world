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

#Create an empty car
def self.create_empty_car(model_id)
  car = Car.new
  car.status = 'empty'
  car.completed = false
  car.car_model_id = model_id
  car.save
  CarModel.find_by(id: model_id).decrease_stock(1);
  return car
end

def delete_all_parts
    self.parts.each do |part|
      part.destroy
    end
  end
end
