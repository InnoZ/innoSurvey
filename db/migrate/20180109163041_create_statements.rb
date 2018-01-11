class CreateStatements < ActiveRecord::Migration[5.1]
  def change
    create_table :statements do |t|
      t.text :style, null: false
      t.text :text, null: false

      t.timestamps
    end
  end
end
