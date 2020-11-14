set :output, 'log/whenever.log'
env :PATH, ENV['PATH']

every 1.minute do
    rake "builder:random_car"
end
