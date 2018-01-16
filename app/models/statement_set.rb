class StatementSet < ApplicationRecord
  belongs_to :topic
  belongs_to :role
  has_many :statements, dependent: :destroy
end
