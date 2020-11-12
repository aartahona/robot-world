class Factory < ApplicationRecord
  belongs_to :car

  validates :car, presence: true, uniqueness: true
end
