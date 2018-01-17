class StatementSet < ApplicationRecord
  belongs_to :topic
  belongs_to :role
  has_many :statements, dependent: :destroy

  delegate :survey, to: :topic, allow_nil: false

  def to_json
    {
      id: id,
      role_id: role.id,
      role_name: role.name,
      statements: statements.map(&:to_json)
    }.to_json
  end
end
