class Survey < ApplicationRecord
  has_many(:stations, dependent: :destroy)
end
