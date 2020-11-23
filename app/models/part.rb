class Part < ApplicationRecord
  TYPES = ["wheel", "chassis", "laser", "computer", "engine", "seat"].freeze

  belongs_to :car

  validates :name, inclusion: { within: TYPES }
  validate :name, :part_quantities, on: :create

  scope :defectives, -> { where("defective = ?", true) }
  

#Validates if the car already includes the part limited quantity
  def  part_quantities
    case self.name

    when "wheel" &&
      if found_all_parts_in_car(self.car_id, self.name, 4) 
        errors.add(:car_id, "This car already includes all 4 wheels")
      end

    when "chassis"
      if found_part_in_car(self.car_id, self.name) 
        errors.add(:car_id, "This car already includes a chassis")
      end

    when "laser"
      if found_part_in_car(self.car_id, self.name) 
        errors.add(:car_id, "This car already includes a laser")
      end

    when "computer"
      if found_part_in_car(self.car_id, self.name)
         errors.add(:car_id, "This car already includes a computer")
      end

    when "engine"
      if found_part_in_car(self.car_id, self.name) 
        errors.add(:car_id, "This car already includes an engine")
      end

    when "seat"
      if found_all_parts_in_car(self.car_id, self.name, 2) 
        errors.add(:car_id, "This car already includes both seats")
      end
    end
  end

private
# Find if a part already exists in the Car
  def found_part_in_car(car_id, part_name)
    Part.find_by( car_id: car_id, name: part_name)
  end
# Find if the limit of parts already exists in the Car
  def found_all_parts_in_car(car_id, part_name, limit)
    Part.where( car_id: car_id, name: part_name).count == limit
  end

end
