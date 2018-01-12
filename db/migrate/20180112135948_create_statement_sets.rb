class CreateStatementSets < ActiveRecord::Migration[5.1]
  def change
    create_table :statement_sets do |t|
      t.references :topic, foreign_key: true
      t.references :role, foreign_key: true

      t.timestamps
    end
  end
end
