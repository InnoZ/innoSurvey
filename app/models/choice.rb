class Choice < ApplicationRecord
  belongs_to(:statement)

  delegate :survey, to: :statement, allow_nil: false
  delegate :topic, to: :statement, allow_nil: false

  validates :text, presence: true, length: { minimum: 1, maximum: 1000 }

  def answers
    Answer.with_choice(id)
  end

  def to_json
    {
      id: id,
      text: text,
    }
  end
end
