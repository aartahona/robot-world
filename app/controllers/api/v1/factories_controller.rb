class Api::V1::FactoriesController < ApplicationController
    # GET /factories
    def index
        @ready_to_sell_cars = Factory.good_condition_cars
        render json:@ready_to_sell_cars
    end


    #The api is going to return a random car from the warehouse, that matches the model id
    #There is a probability that the provided car is already reserved by other pending order
    #TODO improve api so it returns only the non-reserved cars 
    def show
        available_cars = Factory.good_condition_cars
        cars = available_cars.select{|car| car.car_model_id == params[:id].to_i}
        puts cars
        @car_found = cars.sample
        # available_cars.each do |car|
        #     if (car.car_model_id == params[:id].to_i)
        #         @car_found = car
        #         break
        #     end
        # end
        if @car_found == nil
           render json:@car_found, status: 404
        else
            render json:@car_found
        end
    end
end
