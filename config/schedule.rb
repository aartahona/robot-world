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
end

every 5.minute do
    rake "exchanger:verify_exchanges"
end

every 30.minute do
    rake "guard:transfer_cars"
end

every 1.day, at: '00:00 am' do
    rake "builder:destroy_factory"
end