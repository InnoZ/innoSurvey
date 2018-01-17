class Survey < ApplicationRecord
  has_many(:stations, dependent: :destroy)
  belongs_to(:user)

  validates :description, presence: true, length: {  minimum: 10 }
  validates :name, presence: true, length: { in: 5..20 }, uniqueness: true
  validates :name_url_safe, presence: true, length: { in: 5..20 }, uniqueness: true

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
end
