$initializer_logger = Logger.new("#{Rails.root}/log/initializer.log")

desc "Destroy factory. Deletes Cars from warehouse and destroy all cars with their parts as well"
    task destroy_factory: [:environment] do
        ExchangeOrder.destroy_all
        Part.destroy_all
        Factory.destroy_all
        Store.destroy_all
        Order.destroy_all
        Car.destroy_all
end

desc "Fills the CarModel table with different car models"
    task initialize_factory: [:environment] do
        CarModel.create(name: "AUDI A4", year: 2019, price: 20000, cost_price: 15000, stock: 10000)
        CarModel.create(name: "BMW Serie 8", year: 2018, price: 25000, cost_price: 18000, stock: 20000)
        CarModel.create(name: "BMW Serie 7", price: 25000, cost_price: 18000, stock: 30000)
        CarModel.create(name: "TOYOTA Corolla", year: 2017, price: 12000, cost_price: 11000, stock: 40000)
        CarModel.create(name: "FIAT Strada", year: 2016, price: 20000, cost_price: 15000, stock: 500000)
end
