class Statement < ApplicationRecord
  belongs_to(:topic)
  has_many(:choices)
end
