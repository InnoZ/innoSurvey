class Survey < ApplicationRecord
  has_many(:stations, dependent: :destroy)
  has_many(:roles, dependent: :destroy)
  has_many(:topics, through: :stations)
  has_many(:statement_sets, through: :topics)
  has_many(:answers, through: :topics)
  belongs_to(:user)

  validates :description, presence: true, length: {  minimum: 10 }
  validates :name, presence: true, length: { in: 5..100 }, uniqueness: true
  validates :name_url_safe, presence: true, length: { in: 5..100 }, uniqueness: true

  before_validation :make_name_url_safe

  def to_json
    {
      id: id,
      name: name,
      stations: stations.map(&:to_json)
    }
  end

  def make_name_url_safe
    self.name_url_safe = name.
      gsub(/[^\w ]/, '').
      split(' ').
      map(&:downcase).
      join('_')
  end

  def csv
    CSV.generate do |csv|
      csv << %w{ station_name topic_name role_name statement_style statement_text choice_text answer answer_date answer_time }

      csv << [ self.id, self.username, self.email]
    end
  end
end
