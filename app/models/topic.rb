class Topic < ApplicationRecord
  belongs_to(:station)
  has_many(:statement_sets, dependent: :destroy)

  validates :description, presence: true, length: {  minimum: 10 }
end
