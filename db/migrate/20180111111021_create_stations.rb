class CreateStations < ActiveRecord::Migration[5.1]
  def change
    create_table :stations do |t|
      t.references :survey, foreign_key: true

      t.timestamps
    end
  end
end
