class AddUrlSafeNameToSurvey < ActiveRecord::Migration[5.1]
  def change
    add_column :surveys, :name_url_safe, :string
    change_column :surveys, :name_url_safe, :string, null: false
  end
end
