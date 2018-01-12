class Survey < ApplicationRecord
  has_many(:stations, dependent: :destroy)

  validates :description, presence: true, length: {  minimum: 10 }
  validates :name, presence: true, length: { in: 5..20 }
end
