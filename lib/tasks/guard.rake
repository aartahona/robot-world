require "#{Rails.root}/app/models/application_record.rb"
require "#{Rails.root}/app/models/car.rb"
require "#{Rails.root}/app/models/car_model.rb"
require "#{Rails.root}/app/models/factory.rb"
require "#{Rails.root}/app/models/part.rb"

require 'rake'

$logger = Logger.new("#{Rails.root}/log/guard.log")

namespace :guard do

    desc "Search for non-defective cars and set them as ready to sell"
    task verify_cars: [:environment] do
        Factory.get_warehouse_cars.each do |car|
            if car.status == "finished"
                car = Car.find_by(id: car.id )
                car.defective_parts.any? ? log_defective_car(car) : Factory.set_car_as_ready_to_sell(car)
            end   
        end
    end

    def log_defective_car(car)
        Factory.set_car_as_defective(car)

        #Log the defective car
        $logger.info ("Car_id: #{car.id} | Model: #{car.car_model.name} | Year: #{car.car_model.year}")

        #Log the defective parts of the car as well
        car.defective_parts.each do |part|
            $logger.warn ("Part_ID: #{part.id} | Type: #{part.name} | Defective: #{part.defective} | Car_ID: #{part.car_id}")
        end
    end
end
