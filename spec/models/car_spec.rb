require "rails_helper"
RSpec.describe Car do

    it "should be created with all its parameters" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000000)
        car = Car.create(status: "uninitialized", completed: false, car_model_id: car_model.id)

        expect(car).to be_valid
    end

    it "should not be created if there is no stock of the model" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 0)
        car = Car.create(status: "uninitialized", completed: false, car_model_id: car_model.id)
        expect(car).to_not be_valid
    end

    it "should return the defective parts" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000000)
        car = Car.create(status: "uninitialized", completed: false, car_model_id: car_model.id)

        chassis = Part.create(name: "chassis", defective: false, car_id: car.id)
        wheel = Part.create(name: "wheel", defective: true, car_id: car.id)
        laser = Part.create(name: "laser", defective: false, car_id: car.id)
        computer = Part.create(name: "computer", defective: true, car_id: car.id)

        expect(car.defective_parts).to_not include(chassis)
        expect(car.defective_parts).to_not include(laser)
        expect(car.defective_parts).to include(wheel)
        expect(car.defective_parts).to include(computer)
    end

    it "should create an empty car" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000000)
        empty_car = Car.create_empty_car(car_model.id)

        expect(empty_car).to be_valid
        expect(empty_car.status).to eq("empty")
        expect(empty_car.completed).to be false
    end

end