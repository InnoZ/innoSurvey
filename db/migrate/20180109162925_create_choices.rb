class CreateChoices < ActiveRecord::Migration[5.1]
  def change
    create_table :choices do |t|
      t.text :text

      t.timestamps
    end
  end
end
