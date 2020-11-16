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

    desc "Test log to slack"
    task to_slack: [:environment] do
        log_defective_car_to_Slack(Car.last)
    end

    def log_defective_car(car)
        Factory.set_car_as_defective(car)

        #Log the defective car
        $guard_logger.info ("Car_id: #{car.id} | Model: #{car.car_model.name} | Year: #{car.car_model.year}")

        #Log the defective parts of the car as well
        car.defective_parts.each do |part|
            $guard_logger.warn ("Part_ID: #{part.id} | Type: #{part.name} | Defective: #{part.defective} | Car_ID: #{part.car_id}")
        end
        log_defective_car_to_Slack()
    end

    def log_defective_car_to_Slack(car)
        message = "Car: #{car.id} is defective."
        
        car.defective_parts.each do |part|
            message += "\nPart_ID: #{part.id} | Type: #{part.name} | Defective"
        end
        puts message
        
        # response = HTTParty.put("https://jsonplaceholder.typicode.com/posts/1", body: {
        #     id: 1,
        #     title: 'foo',
        #     body: 'bar',
        #     userId: 1,
        # })
        # url = "https://hooks.slack.com/services/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"
        # response = HTTParty.post(
        #     url,
        #     body: { "text" => message }.to_json,
        #     headers: { 'Content-Type' => 'application/json' }
        # )
        # puts response.code
        # puts response.body
    end
end
