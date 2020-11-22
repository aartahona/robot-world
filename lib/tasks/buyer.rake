$buyer_logger = Logger.new("#{Rails.root}/log/buyer.log")

namespace :buyer do

    desc "Attempt to buy a random car"
    task buy_random_car: [:environment] do

        #Gets a random id and checks if there is stock in the store.
        random_id = random_model_id
        Store.get_stock_by_model_id(random_id) > 0 ? buy_random_car(random_id) : log_failed_buy(random_id)
    end

    desc "Attempt to buy 10 random cars"
    task buy_random_car_10times: [:environment] do

        10.times {
            #Gets a random id and checks if there is stock in the store.
            random_id = random_model_id
            Store.get_stock_by_model_id(random_id) > 0 ? buy_random_car(random_id) : log_failed_buy(random_id)
        }        
    end

    desc "Attempt to buy 50 random cars"
    task buy_random_car_50times: [:environment] do

        50.times {
            #Gets a random id and checks if there is stock in the store.
            random_id = random_model_id
            Store.get_stock_by_model_id(random_id) > 0 ? buy_random_car(random_id) : log_failed_buy(random_id)
        }
    end

    desc "Attempt to buy a random number of cars, w/ a maximum 10 cars"
    task buy_random_car_10tops: [:environment] do
        random = rand(1..10)
        $buyer_logger.info ("Attempting to buy #{random} cars")
        random.times {
            #Gets a random id and checks if there is stock in the store.
            random_id = CarModel.ids.sample
            Store.get_stock_by_model_id(random_id) > 0 ? buy_random_car(random_id) : log_failed_buy(random_id)
        }        
    end

    desc "Attempt to buy a random number of cars, w/ a maximum 10 cars. Verifies if there are cars available in the store"
    task buy_random_car_10tops_verify_factory: [:environment] do
        random = rand(1..10)
        $buyer_logger.info ("Attempting to buy #{random} cars")
        random.times {
            #Gets a random id and checks if there is stock in the store.
            random_id = CarModel.ids.sample

            if Store.get_stock_by_model_id(random_id) > 0
                buy_random_car(random_id)
            else
                response = HTTParty.get("http://localhost:3000/api/v1/factories/#{random_id}")

                if response.code == 200
                    car_found = JSON.parse(response.body, object_class: OpenStruct)
                    create_pending_order(car_found.id)
                else
                    log_failed_buy(random_id)
                end
                
            end
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

    def create_pending_order(car_id)
        if Order.find_by(car_id: car_id).nil?
            car = Car.find_by(id: car_id)
            Order.place_an_order(car, 95575523, "ROBOT Alberto Artahona", "pending", car.car_model.price, 2)
            $buyer_logger.info ("Creating Pending Order: Car_id: #{car.id} | Model: #{car.car_model.name} | Year: #{car.car_model.year}")
        else
            $buyer_logger.info ("Car already reserved: Car_id: #{car_id}")
        end
    end

    
    # desc "TEST API checks factory cars"
    # task check_factory_cars: [:environment] do
    #     # check_factory_cars()
    #     find_model_in_factory(30)
    # end

    # def find_model_in_factory(id)
    #     response = HTTParty.get("http://localhost:3000/api/v1/factories/#{id}")
    #     car = JSON.parse(response.body, object_class: OpenStruct)
    #     # if response.code == 200
    #     #     car_found = JSON.parse(response.body, object_class: OpenStruct)
    #     #     create_pending_order(car_found.id)
    #     # end
    #     # puts car.car_model_id.price
    #     puts response.code
    #     puts response.body
    # end

end
