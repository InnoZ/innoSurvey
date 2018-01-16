class Station < ApplicationRecord
  belongs_to :survey
  has_many :topics, dependent: :destroy

  validates :name, presence: true, length: { in: 5..20 }
end
