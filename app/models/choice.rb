class Choice < ApplicationRecord
  belongs_to(:statement)

  delegate :survey, to: :statement, allow_nil: false
  delegate :topic, to: :statement, allow_nil: false

  validates :text, presence: true, length: { mininum: 1, maximum: 100 }

  def to_json
    {
      id: id,
      text: text,
    }.to_json
  end
end
