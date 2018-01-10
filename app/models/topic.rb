class Topic < ApplicationRecord
  belongs_to(:survey)
  belongs_to(:role)
end
