class CarModel < ApplicationRecord
    validates :name, :year, presence: true
end
