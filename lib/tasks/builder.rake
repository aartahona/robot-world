logger = Logger.new("#{Rails.root}/log/builder.log")

namespace :builder do

    desc "Build a new random car"
    task random_car: [:environment] do
        car = produce_random_car
        logger.info ("Car_id: #{car.id} | Model: #{car.car_model.name} | Year: #{car.car_model.year}")
    end

    desc "Build 10 random cars"
    task random_car_10times: [:environment] do
        10.times {
            car = produce_random_car
            logger.info ("Car_id: #{car.id} | Model: #{car.car_model.name} | Year: #{car.car_model.year}")
        }
    end

    #For debugging purposes
    desc "Build 50 random cars"
    task random_car_50times: [:environment] do
        50.times {
            car = produce_random_car
            logger.info ("Car_id: #{car.id} | Model: #{car.car_model.name} | Year: #{car.car_model.year}")
        }
    end

    desc "Destroy factory. Deletes Cars from warehouse and destroy all cars with their parts as well"
    task destroy_factory: [:environment] do
        ExchangeOrder.destroy_all
        Part.destroy_all
        Factory.destroy_all
        Store.destroy_all
        Order.destroy_all
        Car.destroy_all
    end

    #Acts as the ensambler of the factory
    #Calls each stage line,
    def produce_random_car
        car = Factory.create_random_empty_car()
        Factory.basic_structure(car)
        Factory.electronic_devices(car)
        Factory.painting_final_details(car)
        Factory.set_car_as_completed(car)
        return car
    end

  end
