class AddAssosiationsToAnswer < ActiveRecord::Migration[5.1]
  def change
    add_reference :answers, :statement, foreign_key: true
  end
end
