class AddNameToStations < ActiveRecord::Migration[5.1]
  def change
    add_column :stations, :name, :string
    change_column :stations, :name, :string, null: false
  end
end
