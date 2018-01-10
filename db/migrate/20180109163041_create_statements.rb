class CreateStatements < ActiveRecord::Migration[5.1]
  def change
    create_table :statements do |t|
      t.text :type
      t.text :text

      t.timestamps
    end
  end
end
