class AddAssosiationsToStatement < ActiveRecord::Migration[5.1]
  def change
    add_reference :statements, :topic, foreign_key: true
  end
end
