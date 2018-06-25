class Role < ApplicationRecord
  belongs_to(:survey)
  has_many(:statement_sets)
  has_many(:statements, through: :statement_sets)
end
