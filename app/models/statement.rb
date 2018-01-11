class Statement < ApplicationRecord
  belongs_to(:topic)
  has_many(:answers, dependent: :destroy)
  has_many(:choices, dependent: :destroy)
end
