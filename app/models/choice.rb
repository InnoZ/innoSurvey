class Choice < ApplicationRecord
  belongs_to(:statement)

  delegate :survey, to: :statement, allow_nil: false

  validates :text, presence: true, length: { mininum: 1, maximum: 100 }

  def to_json
    {
      id: id,
      text: text,
      statement_id: statement.id
    }
  end
end
