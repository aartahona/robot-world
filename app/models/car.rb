class Car < ApplicationRecord
  belongs_to :car_model
  has_many :parts


end
