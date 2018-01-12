class Survey < ApplicationRecord
  has_many(:stations, dependent: :destroy)

  validates :description, presence: true, length: {  minimum: 10 }
end
