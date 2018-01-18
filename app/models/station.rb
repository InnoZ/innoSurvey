class Station < ApplicationRecord
  belongs_to :survey
  has_many :topics, dependent: :destroy

  validates :name, presence: true, length: { in: 5..100 }

  def to_json
    {
      id: id,
      survey_id: survey.id,
      survey_name: survey.name,
      name: name,
      topics: topics.map(&:to_json)
    }
  end
end
