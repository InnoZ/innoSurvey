class Statement < ApplicationRecord
  STYLES = %w(multiple_choice single_choice)

  belongs_to(:statement_set)
  has_many(:answers, dependent: :destroy)
  has_many(:choices, dependent: :destroy)

  validates :text, presence: true, length: {  minimum: 10, maximum: 100 }
  validates :style, presence: true, inclusion: { in: STYLES }
end
