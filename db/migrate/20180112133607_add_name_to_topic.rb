class AddNameToTopic < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :name, :string
    change_column :topics, :name, :string, null: false
  end
end
