class Api::V1::FactoriesController < ApplicationController
    # GET /factories
    def index
        # @ready_to_sell_cars = Factory.get_warehouse_cars
        @ready_to_sell_cars = Factory.good_condition_cars
        render json:@ready_to_sell_cars
    end
end
