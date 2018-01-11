class Topic < ApplicationRecord
  belongs_to(:station)
  belongs_to(:role)
  has_many(:statements, dependent: :destroy)

  validates :description, presence: true, length: {  minimum: 10 }
end
