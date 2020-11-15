class ExchangeOrder < ApplicationRecord
  belongs_to :order

  validates :order, :status, presence: true
  validates :wanted_model, presence: true

  #Returns an array of pending exchange orders
  def self.get_pending_exchanges
    ExchangeOrder.all.where(status: "pending")
  end

end
