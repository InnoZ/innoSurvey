class Topic < ApplicationRecord
  belongs_to(:station)
  belongs_to(:role)
  has_many(:statements, dependent: :destroy)
end
