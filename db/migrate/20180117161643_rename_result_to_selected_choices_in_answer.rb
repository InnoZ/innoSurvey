class RenameResultToSelectedChoicesInAnswer < ActiveRecord::Migration[5.1]
  def change
    rename_column :answers, :result, :selected_choices
  end
end
