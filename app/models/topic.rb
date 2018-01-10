class Topic < ApplicationRecord
  belongs_to(:survey)
  belongs_to(:role)
  has_many(:statements, dependent: :destroy)
end
