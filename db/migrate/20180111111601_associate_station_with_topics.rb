class AssociateStationWithTopics < ActiveRecord::Migration[5.1]
  def change
    remove_reference :topics, :survey
    add_reference :topics, :station, foreign_key: true
  end
end
