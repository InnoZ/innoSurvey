class Survey < ApplicationRecord
  has_many(:stations, dependent: :destroy)
  belongs_to(:user)

  validates :description, presence: true, length: {  minimum: 10 }
end
