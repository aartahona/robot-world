require "rails_helper"
RSpec.describe CarModel do
    
    it "should be created with all its parameters" do
        car_model = CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 1000000)
        expect(car_model).to be_valid
    end

    it "should not be created without the model name, year or stock" do
        model1 = CarModel.create(year: 2016, price: 20000, cost_price: 15000, stock: 1000000)
        model2 = CarModel.create(name: "Toyota Corolla", price: 12000, cost_price: 11000, stock: 12000)
        model3 = CarModel.create(name: "FORD Fiesta", price: 12000, cost_price: 11000)
        expect(model1).to_not be_valid
        expect(model2).to_not be_valid
        expect(model3).to_not be_valid
    end

    it "should not be created with negative stock" do
        model1 = CarModel.create(year: 2016, price: 20000, cost_price: 15000, stock: -300)
        expect(model1).to_not be_valid
    end

    it "should reduce and increase its stock when required" do
        stock = 300
        amount= 10
        model1 = CarModel.create(year: 2016, price: 20000, cost_price: 15000, stock: stock)
        model2 = CarModel.create(name: "Toyota Corolla", price: 12000, cost_price: 11000, stock: stock)

        model1.decrease_stock(amount)
        model2.increase_stock(amount)

        expect(model1.stock).to be_equal(stock-amount)
        expect(model2.stock).to be_equal(stock+amount)
    end

    it "should return one random Car Model" do
        CarModel.create(name: "AUDI A4", year: 2019, price: 20000, cost_price: 15000, stock: 10000)
        CarModel.create(name: "BMW Serie 8", year: 2018, price: 25000, cost_price: 18000, stock: 20000)
        CarModel.create(name: "BMW Serie 7", price: 25000, cost_price: 18000, stock: 30000)
        CarModel.create(name: "TOYOTA Corolla", year: 2017, price: 12000, cost_price: 11000, stock: 40000)
        CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 500000)
        random_model = CarModel.get_random_car_model
        all_car_models = CarModel.all
        
        expect(all_car_models).to include(random_model)
    end
end