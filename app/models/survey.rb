require 'csv'

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

  CSV_COLUMNS =  %w[
      survey_id
      survey_name
      station_id
      station_name
      topic_id
      topic_name
      statement_set_id
      role_id
      role_name
      statement_id
      statement_text
      statement_style
      choice_id
      choice_text
      choice_selected
  ].freeze

  def to_json
    {
      id: id,
      name: name,
      stations: stations.map(&:to_json)
    }
  end

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << CSV_COLUMNS
      answers.each do |answer|
        # Fetch associated ressources
        statement = answer.statement
        statement_set = statement.statement_set
        topic = statement_set.topic
        station = topic.station
        survey = answer.survey

        answer.choices.each do |choice|
          possible_choices = choice.statement.choices

          csv << [
            survey.id,
            survey.name,
            station.id,
            station.name,
            topic.id,
            topic.name,
            statement_set.id,
            statement_set.role.id,
            statement_set.role.name,
            statement.id,
            statement.text,
            statement.style,
            choice.id,
            choice.text,
            possible_choices.includes?(choice)
          ]
        end
      end
    end
  end

  def make_name_url_safe
    self.name_url_safe = name.
      gsub(/[^\w ]/, '').
      split(' ').
      map(&:downcase).
      join('_')
  end

  private

  def stations_info
  end

  def topics_info(station:)
  end

  def statements_info(topic:)
  end

  def choices_info(statement:)
  end
end
