require "rails_helper"
RSpec.describe Factory do

    it "should not have 2 cars with the same id" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
        car = Car.create(status: "uninitialized", completed: false, car_model_id: car_model.id)

        Factory.create(car_id: car.id) #I add the first car to the factory

        expect(Factory.create(car_id: car.id)).to_not be_valid #I try to add the same car again. It should fail
    end

    it "should create a random empty car" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)

        random_car = Factory.create_random_empty_car
        expect(random_car).to be_valid
        expect(random_car.status).to eq("empty")
        expect(random_car.completed).to be false
    end

    it "should set the basic structure of an empty car" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
        random_car = Factory.create_random_empty_car
        Factory.basic_structure(random_car)

        expect(random_car.status).to eq("basic_structure")
        expect(random_car.parts.where(name: "wheel").count).to eq(4) #Expect to have 4 wheels
        expect(random_car.parts.where(name: "engine").count).to eq(1) #Expect to have an engine
    end

    it "should set the electronic devices of a car" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
        random_car = Factory.create_random_empty_car
        Factory.basic_structure(random_car)
        Factory.electronic_devices(random_car)

        expect(random_car.status).to eq("electronic_devices")
        expect(random_car.parts.where(name: "wheel").count).to eq(4) #Expect to have 4 wheels
        expect(random_car.parts.where(name: "engine").count).to eq(1) #Expect to have an engine
        expect(random_car.parts.where(name: "computer").count).to eq(1) #Expect to have a computer
        expect(random_car.parts.where(name: "laser").count).to eq(1) #Expect to have a laser
    end

    it "should paint the final details of the car" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
        random_car = Factory.create_random_empty_car
        Factory.basic_structure(random_car)
        Factory.electronic_devices(random_car)
        Factory.painting_final_details(random_car)

        expect(random_car.status).to eq("final_details")
        expect(random_car.parts.where(name: "wheel").count).to eq(4) #Expect to have 4 wheels
        expect(random_car.parts.where(name: "engine").count).to eq(1) #Expect to have an engine
        expect(random_car.parts.where(name: "computer").count).to eq(1) #Expect to have a computer
        expect(random_car.parts.where(name: "laser").count).to eq(1) #Expect to have a laser
        expect(random_car.parts.where(name: "chassis").count).to eq(1) #Expect to have a chassis
        expect(random_car.parts.where(name: "seat").count).to eq(2) #Expect to have 2 seats
    end

    it "should set the car as completed" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
        random_car = Factory.create_random_empty_car
        Factory.basic_structure(random_car)
        Factory.electronic_devices(random_car)
        Factory.painting_final_details(random_car)
        Factory.set_car_as_completed(random_car)

        expect(random_car.status).to eq("finished")
        expect(random_car.completed).to be true
        expect(Factory.get_warehouse_cars).to include(random_car)
    end

    it "should set the car as ready to sell" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
        random_car = Factory.create_random_empty_car
        Factory.basic_structure(random_car)
        Factory.electronic_devices(random_car)
        Factory.painting_final_details(random_car)
        Factory.set_car_as_completed(random_car)
        Factory.set_car_as_ready_to_sell(random_car)

        expect(random_car.status).to eq("ready_to_sell")
    end
end