require "rails_helper"
RSpec.describe Order do
    it "should be created with all its parameters" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
        car1 = Car.create(status: "sold", completed: true, car_model_id: car_model.id)
        expect(Order.place_an_order(car1, 95575523, "ROBOT Alberto Artahona", "completed", car1.car_model.price, 2)).to be_valid
    end

    it "shouldn't have a buyer dni with negative number or decimal" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
        car1 = Car.create(status: "sold", completed: true, car_model_id: car_model.id)
        expect(Order.place_an_order(car1, -95575523, "ROBOT Alberto Artahona", "completed", car1.car_model.price, 2)).to_not be_valid
        expect(Order.place_an_order(car1, 0.5, "ROBOT Alberto Artahona", "completed", car1.car_model.price, 2)).to_not be_valid
    end

    it "shouldn't have 2 orders with the same car" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
        car1 = Car.create(status: "sold", completed: true, car_model_id: car_model.id)
        Order.place_an_order(car1, 95575523, "ROBOT Alberto Artahona", "completed", car1.car_model.price, 2) #Place first order

        #Place second order with the same car, expect to fail
        expect(Order.place_an_order(car1, 95575523, "ROBOT Alberto Artahona", "completed", car1.car_model.price, 2)).to_not be_valid 
    end

    it "shouldn't have a final price less or equal than 0" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
        car1 = Car.create(status: "sold", completed: true, car_model_id: car_model.id)
        order1 = Order.place_an_order(car1, 95575523, "ROBOT Alberto Artahona", "completed", -100, 2)
        order2 = Order.place_an_order(car1, 95575523, "ROBOT Alberto Artahona", "completed", 0, 2)

        expect(order1).to_not be_valid
        expect(order2).to_not be_valid
    end

    it "shouldn't have a car that is not completed" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
        car1 = Factory.create_random_empty_car
        order1 = Order.place_an_order(car1, 95575523, "ROBOT Alberto Artahona", "completed", 10500, 2)

        expect(order1).to_not be_valid
    end

    it "should be able to exchange the car from the order" do
        car_model1 = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
        car_model2 = CarModel.create(name: "FORD Fiesta", year: 2015, price: 15000, cost_price: 10000, stock: 1000)

        car1 = Car.create(status: "sold", completed: true, car_model_id: car_model1.id)
        car2 = Car.create(status: "sold", completed: true, car_model_id: car_model2.id)

        order = Order.place_an_order(car1, 95575523, "ROBOT Alberto Artahona", "completed", 10500, 2)
        order.exchange_car(car2)

        expect(order.car_id).to eq(car2.id)
        expect(order.final_price).to eq(car2.car_model.price)
        expect(order.returns_limit).to eq(1)
    end

end