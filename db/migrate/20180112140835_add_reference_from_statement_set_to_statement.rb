class AddReferenceFromStatementSetToStatement < ActiveRecord::Migration[5.1]
  def change
    add_reference :statements, :statement_set, foreign_key: true
    remove_reference :statements, :topic
  end
end
