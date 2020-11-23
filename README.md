# Data Structure
- **Car Model:** This is the "template" for the cars. It provides the prices and the name of the models. Prices are determined by each model and there is a stock for each model that the factory can produce. This table must be filled at the start.

- **Parts:** Each part references to a car and there is a fixed set of parts that can be created. There is a set probability that a part can be created as defective.

- **Cars:** The base model of the project. Each car references a model to know its price. This table persists at all times, starting from the production till an order is placed. We can track the status of each car, so we know which stage the car is.

- **Factory:** This table is only a list of completed cars. The model also has the assembly lines that a car has to pass to be completed.

- **Store:** Similar to the factory, the store is also just a list of cars. It references the 'ready to sell' cars.

- **Orders:** Very similar to Factory and Store. It is basically a list of cars, but references the 'sold' or soon to be sold cars. The price of the order can be different to the price of the model, for flexibility to set discounts if desired. Each order registers the DNI and name of the buyer. An order can have a status of pending when the car is reserved but not yet sold.

- **Exchange Orders:** This table is used for the orders that need to be exchanged by other car. It is basically a list of orders with the model of the car to be exchanged.


# Robots
I set up the robots as rake tasks that can be scheduled as cron jobs. Each robot has a set of tasks that can be scheduled to be run. I used the 'whenever' gem library to help me define cron jobs in Ruby. More info here: https://github.com/javan/whenever
All robots schedules are configured in the “config/schedule.rb” file.
To set up the cron jobs, you need to run the following command: whenever --update-crontab --set environment='development' or just whenever --update-crontab
This will wirte the jobs in the system crontab file.

## Builder Robot
This robot can build a single random car from the available models that have stock.
It will also pass the car through the assembly lines of the factory until it is finished.
Then it will mark the car as completed and add it to the warehouse stock (add it to the Factory table).
It will log the cars produced in the 'log/builder.log' file


## Guard Robot
There are two main tasks that this robot is in charge of:
- **Verify Cars:** It will look the cars that are available in the warehouse. If the car has any defective parts, it will log it in the 'log/guard.log' file. Otherwise, the car will be marked as 'ready to sell'.
- **Transfer Cars:** It will get the ready to sell cars out from the warehouse stock and transfer them to the Store.

The defective cars will also be posted to Slack. 
I used the 'httparty' gem library because it seemed easier to use than the built-in http client from Ruby. More info here: https://github.com/jnunemaker/httparty
If there is some error with the Slack api, it will log that the defective car wasn't able to be posted.

##Buyer Robot
This robot will buy a random car, if there is stock in the Store. If there is no stock of the model, it will log the failed attempt in the 'log/buyer.log' file.
If there is stock it will place an order with my DNI and name.
It can also buy a random number of cars at a time. With a maximum of 10 cars each time.


# "The Problem"
To solve the stock management problem, I created an api for the Factory. It will return a random available car from the Warehouse, that matches the model id that is passed as a parameter.
The api can be found in 'app/controllers/api/v1/factories_controller.rb'

I extended the Buyer robot features to use the Factory api.
So if the Store is out of stock of a certain model, using the api the Buyer robot will search if there is a car available in the Warehouse of the desired model.
If the Warehouse is also out of stock it will simply log the failed attempt to buy a car. 
But if there is stock in the factory, it will create a "Pending" order with the car that the api returned.

I also extended the Guard robot to handle all the pending orders first, before transfering the ready to sell cars to the store.
It will look for the pending orders and complete them marking the reserved cars as "sold".

**To run this solution:**
- Start the server so the api is running: rails server
- Configure the Buyer task in the 'schedule.rb' file: rake buyer:buy_random_car_10tops_verify_factory
- Configure the Guard task in the 'schedule.rb' file: rake guard:transfer_cars_pending_orders


# "The Other Problem"
To handle the exchanges in the orders, I created an "Exchanger" robot.

It will help to set a request of exchange to the user. You can use the command: rake exchanger:request_an_exchange [oder_id] "[wanted_model_name]"
With the order id and the wanted model name, it will place a new request of exchange.
I created the ExchangeOrder model to list all the orders that need to be replaced.

It also has a task to verify and process all the pending exchange requests. I set it to run every 5 minutes.
If the Store has stock for the wanted model, the robot process the exchange and marks the request as completed. The old car gets back to the stock of the Store.
If there is no stock, then the request is cancelled.
Each order has a limit of exchanges that can be processed. If the limit of the order has been reached, then the exchange request is cancelled.

**To run this solution:**
- Place an exchange request: request_an_exchange [oder_id] "[wanted_model_name]"
- Configure the Exchanger task in the 'schedule.rb' file: rake exchanger:verify_exchanges


# "A plus"
I created a Report robot to log the daily revenue, daily cars sold and daily average order value.
Te report can be found as a log in the 'log/report.log' file

**To run this solution:**
- Run the following command: rake report:daily


# Initializer Robot
This robot is in charge to populate the Car Models table, so the project can run.
It is set to run at the start of the day, after the reset of the database.
To run it you can use the following command: 
- rake initializer:destroy_factory
- rake initializer:initialize_factory


# Tests
I used Rspec to create the unit tests of the models.
To run them you can use the following command: rspec spec


# Notes and Things to Improve
I learned a lot with this project. This is the first time for me using Ruby on Rails and I think there are a few features that can be improved in this project:

- **Improve Factory Api:** The api is going to return a random car from the warehouse that matches a model id. There is a probability that the provided car is already reserved by other pending order. We can improve the api so it returns only the 'non-reserved' cars.
- **Use Environment Variables:** We could use environment variables to make the project "configurable". For example, we could configure the Parts types out of the Part model. Or we could configure the probability of a part to be defective (right now it is set as 1/50)
- **Api for exchange orders:** Another take to solve the exchange orders problems is to implement an api in the store for the exchanges. It can be used for integrations in the future.
