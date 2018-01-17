class Answer < ApplicationRecord
  belongs_to(:statement, dependent: :destroy)
end
