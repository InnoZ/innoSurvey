class Choice < ApplicationRecord
  belongs_to(:statement)

  validates :text, presence: true, length: { mininum: 1, maximum: 100 }
end
