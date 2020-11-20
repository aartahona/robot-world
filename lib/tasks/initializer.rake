$initializer_logger = Logger.new("#{Rails.root}/log/initializer.log")

namespace :initializer do

    desc "Destroy factory. Deletes Cars from warehouse and destroy all cars with their parts as well"
        task destroy_factory: [:environment] do
            ExchangeOrder.destroy_all
            Part.destroy_all
            Factory.destroy_all
            Store.destroy_all
            Order.destroy_all
            Car.destroy_all
            CarModel.destroy_all
    end

    desc "Fills the CarModel table with different car models"
        task initialize_factory: [:environment] do
            CarModel.create(name: "AUDI A4", year: 2019, price: 20000, cost_price: 15000, stock: 10000)
            CarModel.create(name: "BMW Serie 8", year: 2018, price: 25000, cost_price: 18000, stock: 20000)
            CarModel.create(name: "BMW Serie 7", price: 25000, cost_price: 18000, stock: 30000)
            CarModel.create(name: "TOYOTA Corolla", year: 2017, price: 12000, cost_price: 11000, stock: 40000)
            CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 500000)
            CarModel.create(name: "PEUGEOT 208", year: 2017, price: 13000, cost_price: 11000, stock: 45000)
            CarModel.create(name: "TOYOTA Hilux", year: 2020, price: 30000, cost_price: 25000, stock: 30000)
            CarModel.create(name: "FORD Ecosport", year: 2015, price: 15000, cost_price: 14000, stock: 20000)
            CarModel.create(name: "TOYOTA Etios", year: 2019, price: 10000, cost_price: 8000, stock: 10000)
            CarModel.create(name: "FIAT Mobi", year: 2018, price: 11000, cost_price: 9000, stock: 25000)
    end
end