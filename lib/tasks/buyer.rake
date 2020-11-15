$buyer_logger = Logger.new("#{Rails.root}/log/buyer.log")

namespace :buyer do

    desc "Attempt to buy a car"
    task buy_random_car: [:environment] do

        #Gets a random id and checks if there is stock in the store.
        random_id = random_model_id
        Store.get_stock_by_model_id(random_id) > 0 ? buy_random_car(random_id) : log_failed_buy(random_id)
    end

    task buy_random_car_10times: [:environment] do

        10.times {
            #Gets a random id and checks if there is stock in the store.
            random_id = random_model_id
            Store.get_stock_by_model_id(random_id) > 0 ? buy_random_car(random_id) : log_failed_buy(random_id)
        }        
    end

    task buy_random_car_50times: [:environment] do

        50.times {
            #Gets a random id and checks if there is stock in the store.
            random_id = random_model_id
            Store.get_stock_by_model_id(random_id) > 0 ? buy_random_car(random_id) : log_failed_buy(random_id)
        }
    end

    task buy_random_car_10tops: [:environment] do
        random = rand(1..10)
        $buyer_logger.info ("Attempting to buy #{random} cars")
        random.times {
            #Gets a random id and checks if there is stock in the store.
            random_id = random_model_id
            Store.get_stock_by_model_id(random_id) > 0 ? buy_random_car(random_id) : log_failed_buy(random_id)
        }        
    end

    #Logs the failed attempt to buy
    def log_failed_buy(random_id)

        model = CarModel.find_by(id: random_id).name
        #Log the model name without stock
        $buyer_logger.warn ("There is no more stock in the store of model: #{model}")
    end

    def buy_random_car(random_id)
        car = Store.get_cars_by_model_id(random_id).sample
        $buyer_logger.info ("Buying: Car_id: #{car.id} | Model: #{car.car_model.name} | Year: #{car.car_model.year}")
        Order.place_an_order(car, 95575523, "ROBOT Alberto Artahona", "completed", car.car_model.price, 2)
        Store.set_car_as_sold(car)
        #Store.find_by(car_id: car.id).destroy
        Store.remove_car_from_store(car)
    end

    #Generates a random model id
    def self.random_model_id
        # rand(CarModel.all.count) + 1
        rand(1..CarModel.all.count)
    end

end
