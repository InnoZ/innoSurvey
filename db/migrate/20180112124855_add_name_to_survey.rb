class AddNameToSurvey < ActiveRecord::Migration[5.1]
  def self.up
    add_column :surveys, :name, :string
    change_column :surveys, :name, :string, null: false
  end

  def self.down
    remove_column :surveys, :name
  end
end
