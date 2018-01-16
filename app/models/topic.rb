class Topic < ApplicationRecord
  belongs_to(:station)
  has_many(:statement_sets, dependent: :destroy)

  delegate :survey, to: :station, allow_nil: false

  validates :description, presence: true, length: {  minimum: 10 }

  def to_json
    {
      id: id,
      station_id: station.name,
      name: name,
      description: description,
      statement_sets: statement_sets.map(&:to_json)
    }
  end
end
