require "rails_helper"
RSpec.describe Part do

    it "should be created with all its parameters" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000000)
        car = Car.create(status: "uninitialized", completed: false, car_model_id: car_model.id)
        chassis = Part.create(name: "chassis", defective: false, car_id: car.id)
        
        expect(chassis).to be_valid
    end

    it "should not be created with an invalid type" do
        invalid_type = "door"
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000000)
        car = Car.create(status: "uninitialized", completed: false, car_model_id: car_model.id)
        chassis = Part.create(name: invalid_type, defective: false, car_id: car.id)

        expect(chassis).to_not be_valid
    end

    it "should not be created without its type" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000000)
        car = Car.create(status: "uninitialized", completed: false, car_model_id: car_model.id)
        chassis = Part.create(defective: false, car_id: car.id)

        expect(chassis).to_not be_valid
    end
end