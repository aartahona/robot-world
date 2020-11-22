require "rails_helper"
RSpec.describe Order do
    it "should be created with all its parameters" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
        car1 = Car.create(status: "sold", completed: true, car_model_id: car_model.id)
        order = Order.place_an_order(car1, 95575523, "ROBOT Alberto Artahona", "completed", car1.car_model.price, 2)
        exchange = ExchangeOrder.create(order_id: order.id, wanted_model: "FORD Fiesta", status: "pending")

        expect(exchange).to be_valid
    end

    it "shouldn't be created without an order or status" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
        car1 = Car.create(status: "sold", completed: true, car_model_id: car_model.id)
        order = Order.place_an_order(car1, 95575523, "ROBOT Alberto Artahona", "completed", car1.car_model.price, 2)

        exchange1 = ExchangeOrder.create(order_id: order.id, wanted_model: "FORD Fiesta")
        exchange2 = ExchangeOrder.create(wanted_model: "FORD Fiesta", status: "pending")

        expect(exchange1).to_not be_valid
        expect(exchange2).to_not be_valid
    end

    it "should return the pending exchanges" do
        car_model1 = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000)
        car_model2 = CarModel.create(name: "FORD Fiesta", year: 2015, price: 15000, cost_price: 10000, stock: 1000)
        car_model3 = CarModel.create(name: "TOYOTA Corolla", year: 2014, price: 10000, cost_price: 5000, stock: 1000)

        car1 = Car.create(status: "sold", completed: true, car_model_id: car_model1.id)
        car2 = Car.create(status: "sold", completed: true, car_model_id: car_model2.id)
        car3 = Car.create(status: "sold", completed: true, car_model_id: car_model3.id)

        order1 = Order.place_an_order(car1, 95575523, "ROBOT Alberto Artahona", "completed", car1.car_model.price, 2)
        order2 = Order.place_an_order(car2, 95575523, "ROBOT Alberto Artahona", "completed", car2.car_model.price, 2)
        order3 = Order.place_an_order(car3, 95575523, "ROBOT Alberto Artahona", "completed", car3.car_model.price, 2)

        exchange1 = ExchangeOrder.create(order_id: order1.id, wanted_model: "FORD Fiesta", status: "pending")
        exchange2 = ExchangeOrder.create(order_id: order2.id, wanted_model: "TOYOTA Corolla", status: "pending")
        exchange3 = ExchangeOrder.create(order_id: order3.id, wanted_model: "FIAT Strada", status: "completed")

        expect(ExchangeOrder.get_pending_exchanges).to include(exchange1)
        expect(ExchangeOrder.get_pending_exchanges).to include(exchange2)
        expect(ExchangeOrder.get_pending_exchanges).to_not include(exchange3)
    end
end