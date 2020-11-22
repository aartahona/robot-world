require "rails_helper"
RSpec.describe Store do

        it "should not have 2 cars with the same id" do
            car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
            car = Car.create(status: "ready_to_sell", completed: true, car_model_id: car_model.id)
    
            Store.create(car_id: car.id) #I add the first car to the store
    
            expect(Store.create(car_id: car.id)).to_not be_valid #I try to add the same car again. It should fail
        end

        it "should not have a car that is not ready to be sold" do
            car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
            random_car = Factory.create_random_empty_car

            expect(Store.add_car_to_store(random_car)).to_not be_valid
        end

        it "should return the stock of a specific model" do
            car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
            car1 = Car.create(status: "ready_to_sell", completed: true, car_model_id: car_model.id)
            car2 = Car.create(status: "ready_to_sell", completed: true, car_model_id: car_model.id)
            car3 = Car.create(status: "ready_to_sell", completed: true, car_model_id: car_model.id)

            Store.add_car_to_store(car1)
            Store.add_car_to_store(car2)
            Store.add_car_to_store(car3)

            expect(Store.get_stock_by_name("FIAT Strada")).to eq(3)
        end

        it "should return the cars of a specific model searching by id" do
            car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
            car1 = Car.create(status: "ready_to_sell", completed: true, car_model_id: car_model.id)
            car2 = Car.create(status: "ready_to_sell", completed: true, car_model_id: car_model.id)
            car3 = Car.create(status: "ready_to_sell", completed: true, car_model_id: car_model.id)

            Store.add_car_to_store(car1)
            Store.add_car_to_store(car2)
            Store.add_car_to_store(car3)

            cars = Store.get_cars_by_model_id(car_model.id)

            expect(cars).to include(car1)
            expect(cars).to include(car2)
            expect(cars).to include(car3)
        end

        it "should set the car as sold" do
            car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
            car1 = Car.create(status: "ready_to_sell", completed: true, car_model_id: car_model.id)
            Store.add_car_to_store(car1)
            Store.set_car_as_sold(car1)

            expect(car1.status).to eq("sold")
        end
end