require "#{Rails.root}/app/models/application_record.rb"
require "#{Rails.root}/app/models/car.rb"
require "#{Rails.root}/app/models/car_model.rb"
require "#{Rails.root}/app/models/factory.rb"
require "#{Rails.root}/app/models/part.rb"

require 'rake'

logger = Logger.new("#{Rails.root}/log/builder.log")

namespace :builder do
    desc "Build 50 random cars"
    task random_car_50times: [:environment] do
        50.times {
            car = Factory.produce_random_car
            logger.info ("Car_id: #{car.id} | Model: #{car.car_model.name} | Year: #{car.car_model.year}")
        }
    end

    desc "Build a new random car"
    task random_car: [:environment] do
        car = Factory.produce_random_car
        logger.info ("Car_id: #{car.id} | Model: #{car.car_model.name} | Year: #{car.car_model.year}")
    end

    desc "Destroy factory. Deletes Cars from warehouse and destroy all cars with their parts as well"
    task destroy_factory: [:environment] do
        Part.destroy_all
        Factory.destroy_all
        Car.destroy_all
    end
  end
