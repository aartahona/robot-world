class CarModel < ApplicationRecord
    validates :name, :year, presence: true
    has_many :cars
end
