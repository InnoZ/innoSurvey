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
      csv << %w{ station_name topic_name role_name statement_style statement_text choice_text answer answer_date }
      binding.pry
      if !survey_has_answers
				raise "No Answers in this Survey"
			end
      Station.where(survey_id: self.id).each do | station |
        Topic.where(station_id: station.id).each do | topic |
          StatementSet.where(topic_id: topic.id).each do | statement_set |
            role = Role.where(id: statement_set.role_id)
            Statement.where(statement_set_id: statement_set.id).each do | statement |
              choices = Choice.where(statement_id: statement.id)
							Answer.where(statement_id: statement.id).each do | answer |
								selected_choices = answer.selected_choices.scan(/\d+/).map(&:to_i)
								choices.each do | choice |
									if selected_choices.include? choice.id
										csv << [ station.name, topic.name, role.name, statement.style, statement.text, choice.text, true, answer.created_at]
									else
										csv << [ station.name, topic.name, role.name, statement.style, statement.text, choice.text, false, answer.created_at]
									end
								end
							end
            end
          end
        end
      end
    end
  end


  def survey_has_anwers
    Station.where(survey_id: self.id).each do | station |
			Topic.where(station_id: station.id).each do | topic |
			  StatementSet.where(topic_id: topic.id).each do | statement_set |
			    Statement.where(statement_set_id: statement_set.id).each do | statement |
            Answer.where(statement_id: statement.id).each { return true }
          end
		    end
		  end
		end
    false
	end
end
