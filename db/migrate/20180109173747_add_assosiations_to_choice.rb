class AddAssosiationsToChoice < ActiveRecord::Migration[5.1]
  def change
    add_reference :choices, :statement, foreign_key: true
  end
end
