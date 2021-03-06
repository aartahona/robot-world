set :output, 'log/whenever.log'
env :PATH, ENV['PATH']

every 1.minute do
    rake "builder:random_car_10times"
end

every 1.minute do
    rake "guard:verify_cars"
end

every 1.minute do
    rake "buyer:buy_random_car_10tops"
    #Using second version of the buyer to check first if there is stock in the factory, when the store is out of stock.
    #rake "buyer:buy_random_car_10tops_verify_factory"

end

every 5.minute do
    rake "exchanger:verify_exchanges"
end

every 30.minute do
    rake "guard:transfer_cars"
    #Using the second version of transfer cars, reviewing the pending orders
    # rake "guard:transfer_cars_pending_orders"
end

every 1.day, at: '00:00 am' do
    rake "initializer:destroy_factory"
    rake "initializer:initialize_factory"
end