class AddUuidToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :uuid, :string
    change_column :answers, :uuid, :string, null: false
  end
end
