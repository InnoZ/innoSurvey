class Station < ApplicationRecord
  belongs_to :survey
  has_many :topics, dependent: :destroy
end
