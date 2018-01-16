class AddAssosiationsToTopics < ActiveRecord::Migration[5.1]
  def change
    add_reference :topics, :survey, foreign_key: true
    add_reference :topics, :role, foreign_key: true
  end
end
