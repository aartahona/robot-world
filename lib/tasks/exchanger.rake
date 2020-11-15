$exchanger_logger = Logger.new("#{Rails.root}/log/exchange.log")

namespace :exchanger do

    desc "Taker the order and the model wanted and places an exchange request"
        task request_an_exchange: [:environment] do
            ARGV.each { |a| task a.to_sym do ; end }
            order_id = ARGV[1].to_i
            wanted_car_model = ARGV[2]

            if order_id == 0 || wanted_car_model.nil?
                puts "Please provide order id and car model"
                puts "Example: $ rake exchanger:request_an_exchange 999 \"Ford Fiesta\" "
            else
                if Order.find_by(id: order_id).nil?
                    puts "The order doesn't exists"
                    $exchanger_logger.warn ("Attempted to exchange Order: #{order_id} with Model: #{wanted_car_model} , but the order doesn't exists")

                else
                    ExchangeOrder.create(order_id: order_id, wanted_model: wanted_car_model, status: "pending") 
                    $exchanger_logger.warn ("Exchange Requested: Order_id: #{order_id} | Requested Car Model: #{wanted_car_model}")     
                end  
            end 
        
    end

    desc "Takes the last order and places a new exchange request"
    task exchange_last_order: [:environment] do
        order = Order.last
        new_model_id = random_model_id
         ( Store.get_stock_by_model_id(new_model_id) > 0) && ( order.returns_limit > 0 ) ? exchange_order(order, new_model_id) : log_failed_exchange(order, new_model_id)
    end

    desc "Processes all exchange requests"
    task verify_exchanges: [:environment] do
        pending_exchanges = ExchangeOrder.get_pending_exchanges
        unless pending_exchanges.empty?
            pending_exchanges.each do |exchange|
                order = Order.find_by(id: exchange.order_id)
                new_model_id = CarModel.find_by(name: exchange.wanted_model).id

                if new_model_id.nil?
                    $exchanger_logger.error ("The car model: #{wanted_model} doesn't exists")
                    exchange.status = "cancelled"
                    exchange.save
                else
                    if ( Store.get_stock_by_model_id(new_model_id) > 0) && ( order.returns_limit > 0 )
                        exchange_order(order, new_model_id)
                        exchange.status = "completed"
                        exchange.save
                    else
                        log_failed_exchange(order, new_model_id)
                        exchange.status = "cancelled"
                        exchange.save
                    end
                end
            end      
        end
    end

    #Generates a random model id
    def self.random_model_id
        rand(1..CarModel.all.count)
    end

    #Logs the failed attempt to exchange
    def log_failed_exchange(order, new_model_id)
        model = CarModel.find_by(id: new_model_id)
        #Log the order
        $exchanger_logger.info ("Order: Order_id: #{order.id} | DNI: #{order.buyer_dni} | Car ID: #{order.car_id} | Car Model: #{order.car.car_model.name}")
        if order.returns_limit == 0
            $exchanger_logger.warn ("Order_id: #{order.id} doesn't accept any more returns")
        else
            $exchanger_logger.warn ("Attempted to exchange with Model: #{model.name} , but there is no stock left")
        end

        
    end

    def exchange_order(order, new_model_id)
        puts "#{order} | #{new_model_id}"
        new_car = Store.get_cars_by_model_id(new_model_id).sample
        puts "#{new_car.car_model.name} | #{new_car.car_model.car_model_id}"
        replaced_car = order.car
        puts "#{replaced_car.car_model.name} | #{replaced_car.car_model.car_model_id}"
        order.exchange_car(new_car)
        Store.set_car_as_sold(new_car)
        Store.remove_car_from_store(new_car)
        replaced_car.status = "ready_to_sell"
        replaced_car.save
        Store.add_car_to_store(replaced_car)
        $exchanger_logger.error ("Car Replaced: Car_id: #{replaced_car.id} | Model: #{replaced_car.car_model.name} | Year: #{replaced_car.car_model.year}")
        $exchanger_logger.warn ("New Car: Car_id: #{new_car.id} | Model: #{new_car.car_model.name} | Year: #{new_car.car_model.year}")
        $exchanger_logger.info ("Order_id: #{order.id} | DNI: #{order.buyer_dni} | Car ID: #{order.car_id} | Price: #{order.final_price}}")
    end


end
