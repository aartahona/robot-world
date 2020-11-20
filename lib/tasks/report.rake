$report_logger = Logger.new("#{Rails.root}/log/report.log")

namespace :report do

    desc "Retrieve daily report"
    task daily: [:environment] do
        daily_orders = Order.all.where(["created_at >= ? AND created_at <= ?", Time.now.beginning_of_day, Time.now.end_of_day])
        revenue = 0

        daily_orders.each do |order|
            revenue += (order.final_price - order.car.car_model.cost_price)
        end

        $report_logger.info ("Number of cars sold today: #{daily_orders.count}")
        $report_logger.info ("Daily Revenue: #{revenue}")
        $report_logger.info ("Average Order Value from today: #{(Order.sum(:final_price)/daily_orders.count).round(2)}") if daily_orders.count > 0



        
    end
end