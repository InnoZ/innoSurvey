class Survey < ApplicationRecord
  has_many(:topics, dependent: :destroy)
end
