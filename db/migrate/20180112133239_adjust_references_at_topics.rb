class AdjustReferencesAtTopics < ActiveRecord::Migration[5.1]
  def change
    remove_column :topics, :role
  end
end
