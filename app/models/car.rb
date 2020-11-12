class Car < ApplicationRecord
  belongs_to :car_model
  has_many :parts

  validates :car_model, presence: true
  validate :car_model, :car_model_stock, on: :create

  #validate if there is a stock for the model
  def car_model_stock
      errors.add(:car_model, "There is no stock of this model") if CarModel.find_by( id: self.car_model_id).stock <= 0
  end

end
