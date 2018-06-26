class Statement < ApplicationRecord
  STYLES = %w(multiple_choice single_choice).freeze

  belongs_to(:statement_set)
  has_many(:answers, dependent: :destroy)
  has_many(:choices, dependent: :destroy)

  delegate :survey, to: :statement_set, allow_nil: false
  delegate :topic, to: :statement_set, allow_nil: false

  validates :text, presence: true, length: {  minimum: 1 }
  validates :style, presence: true, inclusion: { in: STYLES }

  accepts_nested_attributes_for :choices, reject_if: :all_blank, allow_destroy: true

  def to_json
    {
      id: id,
      style: style,
      text: text,
      choices: choices.map(&:to_json)
    }
  end
end
