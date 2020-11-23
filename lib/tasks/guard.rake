$guard_logger = Logger.new("#{Rails.root}/log/guard.log")
require 'httparty'

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

    desc "Transfer the ready to sell cars from the warehouse to the store"
    task transfer_cars: [:environment] do
        Factory.get_warehouse_cars.each do |car|
            if car.status == 'ready_to_sell'
                Store.add_car_to_store(car)
                Factory.remove_car_from_warehouse(car)
            end
        end
    end

    desc "Transfer the ready to sell cars from the warehouse to the store, but verifying first if there are pending orders"
    task transfer_cars_pending_orders: [:environment] do

        #Process the pending orders
        pending_orders = Order.all.where(status: "pending")
        pending_orders.each do |order|
            if order.car.completed && order.car.status == "ready_to_sell"
                order.car.status = "sold"
                order.car.save
                order.set_as_completed
                
                Factory.remove_car_from_warehouse(order.car)
            else
                order.set_as_cancelled
            end
        end

        #Transfer the rest of the cars
        Factory.get_warehouse_cars.each do |car|
            if car.status == 'ready_to_sell'
                Store.add_car_to_store(car)
                Factory.remove_car_from_warehouse(car)
            end
        end
    end

    def log_defective_car(car)
        Factory.set_car_as_defective(car)

        #Log the defective car
        $guard_logger.info ("Car_id: #{car.id} | Model: #{car.car_model.name} | Year: #{car.car_model.year}")
        message = "Car: #{car.id} is defective." #For log to slack

        #Log the defective parts of the car as well
        car.defective_parts.each do |part|
            $guard_logger.warn ("Part_ID: #{part.id} | Type: #{part.name} | Defective: #{part.defective} | Car_ID: #{part.car_id}")
            message += "\nPart_ID: #{part.id} | Type: #{part.name} | Defective" #Adding to slack the parts that are damaged
        end
        
        url = "https://hooks.slack.com/services/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"
        response = HTTParty.post(
            url,
            body: { "text" => message }.to_json,
            headers: { 'Content-Type' => 'application/json' }
        )
        $guard_logger.error ("Unable to post defective cars on slack") if response.code != 200 #If there is some kind of error posting to the Slack API
    end

    def buy_car(random_id)
        car = Store.get_cars_by_model_id(random_id).sample
        $buyer_logger.info ("Buying: Car_id: #{car.id} | Model: #{car.car_model.name} | Year: #{car.car_model.year}")
        Order.place_an_order(car, 95575523, "ROBOT Alberto Artahona", "completed", car.car_model.price, 2)
        Store.set_car_as_sold(car)
    end
end